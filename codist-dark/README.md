# Codist Dark

一款移植自 Visual Studio Codist 黑暗配色的 VS Code 主题，覆盖 **C#、Python 与 Avalonia XAML (.axaml)**，深色背景护眼。

## 特性

- **C# 语法细分着色**：关键字按用途分层（控制流 / 分支 / 循环 / 上下文关键字），类型、字段、属性、方法、参数、泛型参数一目了然。
- **Python 专属配色**：与 C# 同源的 Codist 风格——注释/docstring 绿色斜体、控制流关键字橙色斜体、import 紫色、def/class 蓝色加粗、函数名、类名、参数、self/cls、装饰器、内置类型各有专色。**C# 配色完全不受影响**（详见下文「C# 与 Python 如何互不冲突」）。
- **Avalonia XAML 着色**：XML 标签、属性名、属性值、绑定表达式、注释均单独配色，告别全白。
- **语义高亮**：基于 Roslyn / Pylance 的语义 token 让类、接口、枚举、委托、函数精准配色。

## 安装

### 方法一：VSIX 安装（推荐）

1. 在 VS Code 中打开扩展面板（`Ctrl+Shift+X`）。
2. 右上角 `...` 菜单选择 **"Install from VSIX..."**。
3. 选择 `codist-dark-x.y.z.vsix`，安装完成后记得 **重载窗口**（`Ctrl+Shift+P` → `Developer: Reload Window`）。

### 方法二：源码安装（本地开发用）

```bash
bash install.sh
```

脚本会自动把扩展同步到你本机的扩展目录 `~/.vscode/extensions/local.codist-dark-<版本号>`，装好后在命令面板执行 `Developer: Reload Window` 生效。

## 使用主题

1. 按 `Ctrl+K Ctrl+T`（macOS：`Cmd+K Cmd+T`）。
2. 选择 **Codist Dark**。

## 配色速览

| 元素 | 颜色 |
|------|------|
| C# 关键字（VS dark 蓝） | `#569cd6` |
| C# 控制流关键字 | `#e28e3a` |
| C# 方法名 | `#e46b6b` |
| C# 属性 | `#7abcfe` |
| C# 字段 | `#acac00` |
| C# 参数 | `#ff44a2` 斜体 |
| Python 注释 / docstring | `#57a64a` 斜体 |
| Python 控制流关键字 | `#e28e3a` 斜体 |
| Python import | `#8080ff` |
| Python def / class | `#569cd6` 加粗 |
| Python 函数名 | `#e46b6b` |
| Python 类名 / 异常类型 | `#4ec9b0` |
| Python 参数 | `#ff44a2` 斜体 |
| Python self / cls | `#569cd6` 斜体 |
| Python 装饰器 | `#808080` 斜体 |
| Python 内置类型 int/str... | `#4eb0c9` |
| XAML 标签名 | `#4ec9b0` |
| XAML 属性名 | `#9cdcfe` |
| XAML 属性名局部名 | `#dcdcaa` |
| XAML 属性值 / 绑定 | `#ce9178` |
| 注释 / XAML 注释 | `#808080` 斜体 |

## C# 与 Python 如何互不冲突？

同一个主题文件里 C# 和 Python 各有一套配色，**互不覆盖**，原理有两层：

1. **文本 scope 天然隔离**：C# 规则用 `.cs` 后缀（如 `entity.name.function.cs`），Python 规则用 `.python` 后缀（如 `entity.name.function.python`），编辑器按 scope 精确匹配，两种语言永远不会命中对方的规则。
2. **语义 token 互不发射**：Pylance 专属的 `function`、`decorator`、`selfParameter`、`clsParameter`、`magicFunction`、`builtinConstant`、`import` 等 token，C#/Roslyn **从不发射**；C# 用的是 `method`、`namespace`。因此这些语义规则只作用于 Python。

> 之前 Python「颜色怪」的根因：主题里有几条**无语言后缀的通用规则**（如把 `keyword.control.flow` 染成紫色的分支规则）误命中了 Python，而 Python 又缺少专属配色（注释甚至回退成白色）。现在用更具体的 `.python` 规则覆盖了这些误命中，并补全了 Python 全套专色。

## 为什么 XAML 之前是白色？

XAML（`.axaml`）由 Avalonia 扩展识别为 `source.axaml`（XML 变体），之前主题未给它配置 token 颜色，所有 token 落回默认白。本主题对 `*.xml` 系列 scope（`entity.name.tag.xml`、`entity.other.attribute-name.xml`、`string.quoted.*.xml` 等）补充了配色。

## 重新打包

```bash
bash pack.sh
```

无需要 vsce/npm，本质是手动构造 zip 并写 `.vsixmanifest`。
