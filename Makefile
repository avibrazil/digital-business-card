all:
	inkscape --export-id=ibm-cloud-logo --export-id-only --export-dpi 270 --export-png=passbook/logo@3x.png elements.svg
	inkscape --export-id=ibm-cloud-logo --export-id-only --export-dpi 180 --export-png=passbook/logo@2x.png elements.svg
	inkscape --export-id=ibm-cloud-logo --export-id-only --export-dpi 90 --export-png=passbook/logo.png elements.svg

	inkscape --export-id=pass-thumbnail --export-id-only --export-dpi 270 --export-png=passbook/thumbnail@3x.png elements.svg
	inkscape --export-id=pass-thumbnail --export-id-only --export-dpi 180 --export-png=passbook/thumbnail@2x.png elements.svg
	inkscape --export-id=pass-thumbnail --export-id-only --export-dpi 90 --export-png=passbook/thumbnail.png elements.svg

	inkscape --export-id=pass-icon --export-id-only --export-dpi 270 --export-png=passbook/icon@3x.png elements.svg
	inkscape --export-id=pass-icon --export-id-only --export-dpi 180 --export-png=passbook/icon@2x.png elements.svg
	inkscape --export-id=pass-icon --export-id-only --export-dpi 90 --export-png=passbook/icon.png elements.svg
