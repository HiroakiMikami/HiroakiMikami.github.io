// Change the css file by using user agent.
if ((navigator.userAgent.indexOf('iPhone') > 0 && navigator.userAgent.indexOf('iPad') == -1) || navigator.userAgent.indexOf('iPod') > 0)
  document.write('<link rel="stylesheet" type="text/css" href="bootcards/dist/css/bootcards-ios.min.css">');
else if (navigator.userAgent.indexOf('Android') > 0)
  document.write('<link rel="stylesheet" type="text/css" href="bootcards/dist/css/bootcards-android.min.css">');
else {
  document.write('<link rel="stylesheet" type="text/css" href="bootcards/dist/css/bootcards-desktop.min.css">');
  document.write('<link rel="stylesheet" type="text/css" href="css/main-desktop.css">');
}
