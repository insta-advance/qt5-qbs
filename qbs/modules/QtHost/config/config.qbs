import qbs

Module {
    property bool cursor: true
    property bool evdev: false      // ### default: true
    property bool glib: false       // ### package probe for glib
    property bool kqueue: false     // ### package probe for kqueue
    property bool pcre: true        // ### package probe for pcre
    property bool sse2: true        // ### probe for sse2
    property bool sse3: true        // ### probe for sse3
    property bool ssse3: false      // ### probe for ssse3 -- needs cxxFlag
    property bool sse4_1: true      // ### probe for sse4_1
    property bool sse4_2: true      // ### probe for sse4_2
    property bool avx: true         // ### probe for avx
    property bool avx2: true        // ### probe for avx2
    property string opengl: "es2"   // ### probe for desktop, es2, es3, dynamic
    property bool xcb: false        // ### probe for xcb
    property bool kms: true         // ### probe for kms
    property bool spdy: false       // ### probe for spdy
    property bool ssl: false        // ### probe for ssl
}
