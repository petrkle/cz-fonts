PRODUCT=fonts
VERSION=13.04.3001
SRC=FontsFolder

$(PRODUCT)-$(VERSION).msi: $(PRODUCT).wixobj img/*.jpg img/app.ico
	light.exe -sacl -nologo -ext WixUIExtension -ext WixUtilExtension -cultures:cs-cz -out $(PRODUCT)-$(VERSION).msi $(PRODUCT).wixobj

$(PRODUCT).wixobj: $(PRODUCT).wxs files.wxs components.wxs minimalui.wxs
	candle.exe -nologo -dProductVersion=$(VERSION) -dProductName=$(PRODUCT) -dSRC=$(SRC) $(PRODUCT).wxs

clean:
	del /F /Q $(PRODUCT).wixobj $(PRODUCT)-$(VERSION).wixpdb $(PRODUCT)-$(VERSION).msi components.wxs files.wxs sed*

install:
	msiexec /qr /i $(PRODUCT)-$(VERSION).msi

uninstall:
	msiexec /qr /x $(PRODUCT)-$(VERSION).msi

components.wxs: components.xsl
	heat dir $(SRC) -var var.SRC -indent 1 -sw5150 -nologo -ag -suid -ke -sfrag -t components.xsl -out components.wxs

files.wxs: files.xsl
	heat dir $(SRC) -var var.SRC -indent 1 -sw5150 -nologo -ag -suid -ke -sfrag -t files.xsl -out files.wxs
	sed -i 's/Source=/TrueType="yes" Source=/' files.wxs
