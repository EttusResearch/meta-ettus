# X11 for the USRP Embedded

require usrp-embedded-console-image.bb

IMAGE_EXTRA_INSTALL ?= ""

SPLASH ?= "psplash"
#SPLASH ?= "exquisite exquisite-themes exquisite-theme-angstrom"

APPS = " \
  abiword-meta \
  cheese \
  claws-mail \
  evince \
#  ekiga \
#  empathy \
#  firefox \
#  gecko-mediaplayer-firefox-hack \
  gimp \
#  gnome-games \
  gnome-mplayer \
  gnumeric \
  gpe-scap \
  gpe-soundbite \
  jaaa \
  midori \
  nautilus \
  numptyphysics \
#  libgles-omap3-x11demos \
  pidgin \
#  swfdec \
#  swfdec-mozilla \
  synergy \
  vnc \
  x11vnc \
  angstrom-x11vnc-xinit \
  xmms \
  xterm \
 "

E_CONFIG = " \
  e-wm-config-angstrom \
  e-wm-config-angstrom-widescreen \
  e-wm-config-illume \
  e-wm-config-standard \
  e-wm-config-netbook \
  e-wm-config-default \
  e-wm-config-minimalist \
  e-wm-config-scaleable \
 "

E_MODULES = " \
  news \
  places \
 "

E17 = " \
  e-wm \
  e-wm-menu \
  e-wm-sysactions \
  ${E_CONFIG} \
  ${E_MODULES} \
 "

FONTS = " \
  ttf-dejavu-common \
  ttf-dejavu-sans \
  ttf-dejavu-serif \
  ttf-dejavu-sans-mono \
 "  

MEDIA = " \
#  bigbuckbunny-180 \
 "

PRINT = " \
  cups \
  gnome-cups-manager \
  gtk-printbackend-cups \
 "

SETTINGS = " \
  networkmanager network-manager-applet networkmanager-openvpn \
  gnome-bluetooth \
  gpe-conf \
#  gpe-package \
 "

XSERVER_BASE = " \
  ${XSERVER} \
  dbus-x11 \
  fontconfig-utils \
  gnome-icon-theme angstrom-gnome-icon-theme-enable \
  gnome-themes \
  gpe-theme-clearlooks \
  gtk-engine-clearlooks \
  gpe-dm \
  gpe-session-scripts \
  hicolor-icon-theme \
  mime-support \
  xauth \
  xdg-utils \
  xhost \
  xset \
  xlsfonts \
  xrefresh \
 "

IMAGE_INSTALL += " \
  ${APPS} \
  ${E17} \
  ${FONTS} \
  ${MEDIA} \
  ${PRINT} \
  ${SETTINGS} \
  ${SPLASH} \
  ${XSERVER_BASE} \
 "

