//svg data here...
const baseSVGPath = 'assets/svg/';

//image data here...
const baseImagePath = 'assets/images/';

//json data here...
const baseJsonPath = 'assets/json/';

//images
// final kenirmanLogoImage = _getImageBasePath('app_logo.png');

//svgs
final kAttachSvg = _getSvgBasePath('attach.svg');
final kGallerySvg = _getSvgBasePath('gallery.svg');
final kMicSvg = _getSvgBasePath('mic.svg');

//jsons
final kVoiceRecordActiveJson = _getJsonBasePath('voice_record_active.json');

//network image
// final kOnboardingUrl = _getNetworkImageBasePath('onboarding.png');

//svg function here...
String _getSvgBasePath(String name) {
  return baseSVGPath + name;
}

//image function here...
String _getImageBasePath(String name) {
  return baseImagePath + name;
}

//json function here...
String _getJsonBasePath(String name) {
  return baseJsonPath + name;
}
