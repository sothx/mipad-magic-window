
const fs = require('fs');
const xml2js = require('xml2js');
const path = require('path');

function pkFullRuleConfig(cb) {
    const parser = new xml2js.Parser();
    const builder = new xml2js.Builder({ renderOpts: { 'pretty': true } });
    let embeddedPackages = [];
    let fixedPackages = [];

    fs.readFile('input_pk_config/embedded_rules_list.xml', (err, data) => {
        if (err) throw err;
        parser.parseString(data, (err, result) => {
            if (err) throw err;
            const packages = result.package_config.package;

            if (Array.isArray(packages)) {
                embeddedPackages = packages.filter(pkg => pkg.$.fullRule);
            } else if (packages.$.fullRule) {
                embeddedPackages.push(packages);
            }

            fs.readFile('input_pk_config/fixed_orientation_list.xml', (err, data) => {
                if (err) throw err;
                parser.parseString(data, (err, result) => {
                    if (err) throw err;
                    const packages = result.package_config.package;

                    if (Array.isArray(packages)) {
                        fixedPackages = packages.map(pkg => pkg.$.name);
                    } else {
                        fixedPackages.push(packages.$.name);
                    }

                    const newPackages = embeddedPackages.filter(pkg => !fixedPackages.includes(pkg.$.name));

                    // 格式化新的包
                    const outputPackages = newPackages.map(pkg => ({
                        $: {
                            name: pkg.$.name,
                            supportModes: "full,fo" // 可以根据需要修改 supportModes 的值
                        }
                    }));

                    const outputXml = {
                        package_config: {
                            package: outputPackages
                        }
                    };

                    const xmlString = builder.buildObject(outputXml);
                    fs.writeFile(path.join('output_temp/json/', 'pkFullRuleConfig.xml'), xmlString, (err) => {
                        if (err) throw err;
                        cb();
                    });
                });
            });
        });
    });
}

function pkDisableConfig(cb) {
    const parser = new xml2js.Parser();
    let embeddedPackages = [];
    let fixedPackages = [];
    const outputDir = 'output_temp/json/';
    const outputFile = path.join(outputDir, 'pkDisableConfig.ejs');

    // 确保输出目录存在
    if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
    }

    // 读取 embedded_rules_list.xml
    fs.readFile('input_pk_config/embedded_rules_list.xml', (err, data) => {
        if (err) throw err;
        parser.parseString(data, (err, result) => {
            if (err) throw err;
            const packages = result.package_config.package;

            if (Array.isArray(packages)) {
                embeddedPackages = packages.filter(pkg => pkg.$.fullRule);
            } else if (packages.$.fullRule) {
                embeddedPackages.push(packages);
            }

            // 读取 fixed_orientation_list.xml
            fs.readFile('input_pk_config/fixed_orientation_list.xml', (err, data) => {
                if (err) throw err;
                parser.parseString(data, (err, result) => {
                    if (err) throw err;
                    const packages = result.package_config.package;

                    if (Array.isArray(packages)) {
                        fixedPackages = packages.filter(pkg => pkg.$.disable === 'true');
                    } else if (packages.$.disable === 'true') {
                        fixedPackages.push(packages);
                    }

                    // 创建 EJS 模板内容
                    let output = '';
                    fixedPackages.forEach(fixedPkg => {
                        const embeddedPkg = embeddedPackages.find(pkg => pkg.$.name === fixedPkg.$.name);
                        if (embeddedPkg) {
                            // 如果在 embeddedPackages 中找到，则使用支持模式
                            output += `<%_ if (Number(mi_os_version) >= 2) { _%>\n`;
                            output += `  <package name="${fixedPkg.$.name}" supportModes="full,fo" defaultSettings="full"${generateAttributes(fixedPkg.$, ['disable','name','supportModes','defaultSettings'])} />\n`;
                            output += `<%_ } else { _%>\n`;
                            // else 中保持 fixedPkg 的原样
                            output += `  <package name="${fixedPkg.$.name}"${generateAttributes(fixedPkg.$, ['name','supportModes'])} />\n`;
                            output += `<%_ } _%>\n`;
                        }
                    });

                    // 写入到文件
                    fs.writeFile(outputFile, output, (err) => {
                        if (err) throw err;
                        cb();
                    });
                });
            });
        });
    });
}

// 生成动态属性
function generateAttributes(pkg, excludeKeys = []) {
    return Object.entries(pkg)
        .filter(([key]) => !excludeKeys.includes(key)) // 排除指定的键
        .map(([key, value]) => ` ${key}="${value}"`)
        .join('');
}


module.exports = {
    pkFullRuleConfig,
    pkDisableConfig
  }