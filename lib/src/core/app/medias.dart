//svg data here...
const baseSVGPath = 'assets/svg/';

//image data here...
const baseImagePath = 'assets/images/';

//json data here...
const baseJsonPath = 'assets/json/';

//images
final kAppIconImage = _getImageBasePath('app_icon.png');
final kAppIcon2Image = _getImageBasePath('app_icon2.png');

//svgs
final kAttachSvg = _getSvgBasePath('attach.svg');
final kGallerySvg = _getSvgBasePath('gallery.svg');
final kMicSvg = _getSvgBasePath('mic.svg');
final kAddNoteSvg = _getSvgBasePath('add_note.svg');
final kPinSvg = _getSvgBasePath('pin.svg');

//jsons
final kVoiceRecordActiveJson = _getJsonBasePath('voice_record_active.json');
final kVoicePlayJson = _getJsonBasePath('voice_play.json');

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
