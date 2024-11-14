const { src, dest, parallel, series } = require("gulp");
const { cleanTemp } = require("./cleanDir");
const { options } = require("../config/process.env");
const gulpIf = require("gulp-if");
const fs = require('fs');
const gulpXML = require("gulp-xml");
const DOMParser = require("xmldom").DOMParser;
const { pd } = require('pretty-data');
const XMLSerializer = require("xmldom").XMLSerializer;
const through2 = require('through2');
const Vinyl = require("vinyl");

const buildActionIsMagicWindow = function () {
  const use_mode = options.use_mode;
  const is_magicWindow = use_mode === "magicWindow";
  return is_magicWindow;
};

const buildActionIsActivityEmbedding = function () {
  const use_mode = options.use_mode;
  const is_activityEmbedding = use_mode === "activityEmbedding";
  return is_activityEmbedding;
};

const moduleSrc = "module_src";
const tempDir = "temp";
const commonDist = "dist/common";
const systemDist = "dist";

let magicWindowApplicationListStack = {};

/**
 * 混入公共配置
 */

function copyREADME(cb) {
  return src(`README.md`)
    .pipe(dest(`${systemDist}/`))
    .on("end", cb);
}

/**
 * 混入Android 11 下的平行窗口配置
 */

function copyMagicWindowApplicationList(cb) {
  return src(`${tempDir}/magicWindowFeature_magic_window_application_list.xml`)
    .pipe(
      gulpIf(
        buildActionIsMagicWindow,
        gulpXML({
          callback: function (result) {
            const doc = new DOMParser().parseFromString(result, "text/xml");
            const elementsWithAttribute = doc.getElementsByTagName("package");
            for (let i = 0; i < elementsWithAttribute.length; i++) {
              const attrs = elementsWithAttribute[i].attributes;
              const currentAttrName =
                elementsWithAttribute[i].getAttribute("name");
              if (currentAttrName) {
                magicWindowApplicationListStack[currentAttrName] = {};
                for (var j = attrs.length - 1; j >= 0; j--) {
                  magicWindowApplicationListStack[currentAttrName][
                    attrs[j].name
                  ] = attrs[j].value;
                }
              }
            }
          },
        })
      )
    )
    .pipe(gulpIf(buildActionIsMagicWindow, dest(`${commonDist}/source/`)))
    .on("end", cb);
}

function copyMagicWindowSettingConfig(cb) {
  return src(`${tempDir}/magic_window_setting_config.xml`)
    .pipe(
      gulpIf(
        buildActionIsMagicWindow,
        gulpXML({
          callback: function (result) {
            const doc = new DOMParser().parseFromString(result, "text/xml");
            // 获取根节点
            const settingConfigNode =
              doc.getElementsByTagName("setting_config")[0];
            for (const [key] of Object.entries(
              magicWindowApplicationListStack
            )) {
              // 创建一个新元素
              const newElement = doc.createElement("setting");
              newElement.setAttribute("name", key);
              newElement.setAttribute("miuiMagicWinEnabled", "true");
              newElement.setAttribute("miuiDialogShown", "false");
              newElement.setAttribute("miuiDragMode", "0");
              // 创建一个包含两个空格的文本节点
              const spaceTextNode = doc.createTextNode("  "); // 两个空格
              settingConfigNode.appendChild(spaceTextNode);
              // 将文本节点附加到新元素
              settingConfigNode.appendChild(newElement);
              // 添加换行符
              const newLineNode = doc.createTextNode("\n");
              settingConfigNode.appendChild(newLineNode);
            }
            const serializedXml = new XMLSerializer().serializeToString(doc);
            // 使用正则表达式删除空行
            const cleanedXml = serializedXml.replace(
              /^\s*[\r\n]|[\r\n]+\s*$/gm,
              ""
            );
            return cleanedXml;
          },
        })
      )
    )
    .pipe(gulpIf(buildActionIsMagicWindow, dest(`${commonDist}/source/`)))
    .on("end", cb);
}

/**
 * 混入Android 11 的自定义规则模板
 */

function copyMagicWindowCustomConfigTemplateToCommon(cb) {
  return src(`${moduleSrc}/template/custom_config/magicWindow/*`)
    .pipe(gulpIf(buildActionIsMagicWindow, dest(`${commonDist}/template/`)))
    .on("end", cb);
}

/**
 * 混入Android 12L 起的平行窗口配置
 */

function copyEmbeddedRuleListToCommon(cb) {
  return src([
    `${tempDir}/embedded_rules_list.xml`,
    `${tempDir}/embedded_rules_list_projection.xml`,
  ])
    .pipe(gulpIf(buildActionIsActivityEmbedding, dest(`${commonDist}/source/`)))
    .on("end", cb);
}

/**
 * 混入Android 12L 起的修正方向位置的配置
 */

function copyFixedOrientationListToCommon(cb) {
  return src([
    `${tempDir}/fixed_orientation_list.xml`,
    `${tempDir}/fixed_orientation_list_projection.xml`,
  ])
    .pipe(gulpIf(buildActionIsActivityEmbedding, dest(`${commonDist}/source/`)))
    .on("end", cb);
}

/**
 * 混入Android 12L 起的应用布局优化的配置
 */

function copyAutoUiListToCommon(cb) {
  return src(`${tempDir}/autoui_list.xml`)
    .pipe(gulpIf(buildActionIsActivityEmbedding, dest(`${commonDist}/source/`)))
    .on("end", cb);
}

/**
 * 混入Android 12L 起的Overlay配置
 */

// function copyActivityEmbeddingOverlayToCommon(cb) {
//   return src(`${moduleSrc}/overlay/*`)
//   .pipe(gulpIf(buildActionIsActivityEmbedding,dest(`${commonDist}/overlay`)))
// }

/**
 * 混入Android 12L 起的主题Overlay配置
 */

function copyActivityEmbeddingThemeOverlayToCommon(cb) {
  return src(`${moduleSrc}/theme_overlay/*`)
    .pipe(
      gulpIf(
        buildActionIsActivityEmbedding,
        dest(`${commonDist}/theme_overlay`)
      )
    )
    .on("end", cb);
}

/**
 * 混入Android 12L 起的自定义规则模板
 */

function copyActivityEmbeddingCustomConfigTemplateToCommon(cb) {
  return src(`${moduleSrc}/template/custom_config/activityEmbedding/*`)
    .pipe(
      gulpIf(buildActionIsActivityEmbedding, dest(`${commonDist}/template/`))
    )
    .on("end", cb);
}

/**
 * 混入 Hyper OS 2.0起的通用规则
 *
 */

function copyGenericRulesToCommon(cb) {
  return src([
    `${tempDir}/generic_rules_list.xml`,
    `${tempDir}/generic_rules_list_projection.xml`,
  ])
    .pipe(gulpIf(buildActionIsActivityEmbedding, dest(`${commonDist}/source/`)))
    .on("end", cb);
}

/**
 * 混入 Hyper OS 2.0起的应用横屏布局配置文件
 */

function parseXml(filePath) {
  const xmlContent = fs.readFileSync(filePath, 'utf-8');
  return new DOMParser().parseFromString(xmlContent, 'application/xml');
}

function generateEmbeddedSettingConfig(cb) {
  if (!buildActionIsActivityEmbedding) {
    cb()
    return;
  }
  if (options.mi_os_version < 2) {
    cb()
    return;
  }
  if (options.use_platform !== 'pad') {
    cb()
    return;
  }
  const embeddedRulesList = parseXml('temp/embedded_rules_list.xml');
  const fixedOrientationList = parseXml('temp/fixed_orientation_list.xml');
  const settingDoc = new DOMParser().parseFromString(
    "<setting_rule></setting_rule>",
    "application/xml"
  );
  const settingRoot = settingDoc.documentElement;

  const fixedPackages =
    Array.from(fixedOrientationList.getElementsByTagName("package"));
  const embeddedPackages =
    Array.from(embeddedRulesList.getElementsByTagName("package"));

  const uniquePackages = new Map();


  fixedPackages.map((pkg) => {
    const name = pkg.getAttribute("name");
    if (name) {
      uniquePackages.set(name, {
        fixedPkg: pkg,
        embeddedPkg: null, // Start with no embeddedPkg
      });
    }
  });

  embeddedPackages.forEach((pkg) => {
    const name = pkg.getAttribute("name");
    if (name) {
      if (uniquePackages.has(name)) {
        uniquePackages.get(name).embeddedPkg = pkg; // Attach embeddedPkg if it exists
      } else {
        uniquePackages.set(name, {
          fixedPkg: null, // No fixedPkg initially
          embeddedPkg: pkg,
        });
      }
    }
  });

  uniquePackages.forEach(({ fixedPkg, embeddedPkg }, pkgName) => {
    let embeddedEnable = "false";
    let fixedOrientationEnable = "false";
    let ratio_fullScreenEnable = "false";
    let fullScreenEnable = "false";

    // Check if fixedPkg exists and has necessary attributes

    fixedOrientationEnable = "true";

    const supportModes = fixedPkg ? fixedPkg.getAttribute("supportModes")?.split(',') : null;
    const defaultSettings = fixedPkg ? fixedPkg.getAttribute("defaultSettings") : null;
    const fullRule = embeddedPkg ? embeddedPkg.getAttribute("fullRule") : null;

    if (fixedPkg && fixedPkg.getAttribute("disable") === "false"){
      return;
    }


    if (
      supportModes &&
      supportModes.includes("full") &&
      (!defaultSettings || defaultSettings === "full")
    ) {
      ratio_fullScreenEnable = "true";
      fixedOrientationEnable = "false";
      if (fullRule) {
        fullScreenEnable = "true";
      }
    }

    // Check if embeddedPkg exists and handle the embeddedRule enable
    if (embeddedPkg && !embeddedPkg.getAttribute("fullRule") && (!defaultSettings || defaultSettings === 'ae')) {
      embeddedEnable = "true";
      ratio_fullScreenEnable = "false";
      fixedOrientationEnable = "false";
      fullScreenEnable = "false";
    }

    const setting = settingDoc.createElement("setting");
    setting.setAttribute("name", pkgName);
    if (embeddedPkg && !fullRule) {
      setting.setAttribute("embeddedEnable", embeddedEnable);
    }
    if (fixedPkg) {
      setting.setAttribute("fixedOrientationEnable", fixedOrientationEnable);
      if (fullRule) {
        setting.setAttribute("fullScreenEnable", fullScreenEnable);
      }
      setting.setAttribute("ratio_fullScreenEnable", ratio_fullScreenEnable);
    }
    settingRoot.appendChild(setting);
    
  });


  const xmlOutput = new XMLSerializer().serializeToString(settingDoc);

  // Add the XML declaration manually
  const xmlWithDeclaration = `<?xml version='1.0' encoding='utf-8' standalone='yes' ?>\n` + xmlOutput;

  const formattedXml = pd.xml(xmlWithDeclaration);  // 使用 pretty-data 格式化 XML
  fs.writeFileSync(`${commonDist}/source/embedded_setting_config.xml`, formattedXml);

  cb()
  
}

module.exports = series(
  parallel(
    copyREADME,
    series(
      copyMagicWindowApplicationList,
      copyMagicWindowSettingConfig,
      copyMagicWindowCustomConfigTemplateToCommon
    ),
    copyEmbeddedRuleListToCommon,
    copyFixedOrientationListToCommon,
    generateEmbeddedSettingConfig,
    copyAutoUiListToCommon,
    copyActivityEmbeddingCustomConfigTemplateToCommon,
    copyGenericRulesToCommon,
    copyActivityEmbeddingThemeOverlayToCommon
  ),
  cleanTemp
);
