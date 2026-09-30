#!/bin/bash
# 把 codist-dark 扩展打包成 .vsix（无需 npm/vsce，vsix 本质是 zip）
set -e
cd "$(dirname "$0")"

VERSION=$(python3 -c "import json; print(json.load(open('codist-dark/package.json'))['version'])")
DISPLAY=$(python3 -c "import json; print(json.load(open('codist-dark/package.json'))['displayName'])")
DESC=$(python3 -c "import json; print(json.load(open('codist-dark/package.json'))['description'])")

export VERSION DISPLAY DESC
python3 - <<'EOF'
import zipfile, os

version = os.environ['VERSION']
manifest = f'''<?xml version="1.0" encoding="utf-8"?>
<PackageManifest Version="2.0.0" xmlns="http://schemas.microsoft.com/developer/vsx-schema/2011" xmlns:d="http://schemas.microsoft.com/developer/vsx-schema-design/2011">
  <Metadata>
    <Identity Language="en-US" Id="codist-dark" Version="{version}" Publisher="local"/>
    <DisplayName>{os.environ['DISPLAY']}</DisplayName>
    <Description xml:space="preserve">{os.environ['DESC']}</Description>
    <Tags>theme,color-theme,csharp,python,xaml</Tags>
    <Categories>Themes</Categories>
    <GalleryFlags>Public</GalleryFlags>
    <Properties>
      <Property Id="Microsoft.VisualStudio.Code.Engine" Value="^1.60.0"/>
      <Property Id="Microsoft.VisualStudio.Code.ExtensionDependencies" Value=""/>
      <Property Id="Microsoft.VisualStudio.Code.ExtensionPack" Value=""/>
      <Property Id="Microsoft.VisualStudio.Code.ExtensionKind" Value="ui,workspace"/>
      <Property Id="Microsoft.VisualStudio.Code.LocalizedLanguages" Value=""/>
    </Properties>
  </Metadata>
  <Installation>
    <InstallationTarget Id="Microsoft.VisualStudio.Code"/>
  </Installation>
  <Assets>
    <Asset Type="Microsoft.VisualStudio.Code.Content" Path="extension/package.json" Addressable="true"/>
  </Assets>
</PackageManifest>
'''

content_types = '''<?xml version="1.0" encoding="utf-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="json" ContentType="application/json"/>
  <Default Extension="vsixmanifest" ContentType="text/xml"/>
</Types>
'''

out = f'codist-dark-{version}.vsix'
with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as z:
    z.writestr('[Content_Types].xml', content_types)
    z.writestr('extension.vsixmanifest', manifest)
    z.write('codist-dark/package.json', 'extension/package.json')
    z.write('codist-dark/themes/codist-dark-color-theme.json',
            'extension/themes/codist-dark-color-theme.json')
    z.write('README.md', 'extension/README.md')
print('written:', os.path.abspath(out))
EOF
