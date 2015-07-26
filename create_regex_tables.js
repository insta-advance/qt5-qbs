// JavaScript port of create_regex_tables
// Copyright (C) 2015 Intopalo
//   Generates equivalent output to python create_regex_tables
//   Example usage: node -e 'var tables = require("./create_regex_tables.js"); console.log(tables.arrays); console.log(tables.functions);'

// Copyright (C) 2010, 2013 Apple Inc. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY APPLE INC. ``AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL APPLE INC. OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
// OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function ord(str) {
    return str.charCodeAt(0);
}

function zeroPad(str, length) {
    while (str.length < length)
        str = '0' + str;
    return str;
}

var types = {
    wordchar: { UseTable: true, data: ['_', ['0', '9'], ['A', 'Z'], ['a','z']]},
    nonwordchar: { UseTable: true, Inverse: "wordchar", data: ['`', [0, ord('0') - 1], [ord('9') + 1, ord('A') - 1], [ord('Z') + 1, ord('_') - 1], [ord('z') + 1, 0xffff]] },
    newline: { UseTable: false, data: ['\n', '\r', 0x2028, 0x2029] },
    spaces: { UseTable: true, data: [' ', ['\t', '\r'], 0xa0, 0x1680, 0x180e, 0x2028, 0x2029, 0x202f, 0x205f, 0x3000, [0x2000, 0x200a], 0xfeff] },
    nonspaces: { UseTable: true, Inverse: "spaces", data: [[0, ord('\t') - 1], [ord('\r') + 1, ord(' ') - 1], [ord(' ') + 1, 0x009f], [0x00a1, 0x167f], [0x1681, 0x180d], [0x180f, 0x1fff], [0x200b, 0x2027], [0x202a, 0x202e], [0x2030, 0x205e], [0x2060, 0x2fff], [0x3001, 0xfefe], [0xff00, 0xffff]] },
    digits: { UseTable: false, data: [['0', '9']] },
    nondigits: { UseTable: false, Inverse: "digits", data: [[0, ord('0') - 1], [ord('9') + 1, 0xffff]] }
};

var entriesPerLine = 50;
var arrays = "";
var functions = "";
var emitTables = true; // set to false for --no-tables

// To match python output exactly, use this name index: ["nonspaces", "nonwordchar", "nondigits", "wordchar", "newline", "digits", "spaces"]
for (var name in types) {
    var classes = types[name];
    var ranges = [];
    var size = 0;
    for (var c in classes.data) {
        var _class = classes.data[c];
        switch (typeof(_class)) {
        case "string":
            ranges.push([ord(_class), ord(_class)]);
            continue;
        case "number":
            ranges.push([_class, _class]);
            continue;
        default:
            var min = _class[0];
            var max = _class[1];
            if (typeof(min) === "string")
                min = ord(min);
            if (typeof(max) == "string")
                max = ord(max);
            if (max > 0x7f && min <= 0x7f) {
                ranges.push([min, 0x7f]);
                min = 0x80;
            }
            ranges.push([min, max]);
            continue;
        }
    }
    ranges.sort(function(a, b) {
        if (a[0] === b[0]) {
            if (a[1] === b[1])
                return 0;
            return a[1] < b[1] ? -1 : 1;
        }
        return a[0] < b[0] ? -1 : 1;
    });

    if (emitTables && classes.UseTable && !("Inverse" in classes)) {
        var array = "static const char _" + name + "Data[65536] = {\n";
        var i = 0
        for (var r in ranges) {
            var min = ranges[r][0];
            var max = ranges[r][1];
            while (i < min) {
                i = i + 1;
                array += "0,";
                if (i % entriesPerLine === 0 && i !== 0)
                    array += '\n';
            }
            while (i <= max) {
                i = i + 1
                if (i == 65536)
                    array += "1";
                else
                    array += "1,";
                if (i % entriesPerLine === 0 && i !== 0)
                    array += "\n";
            }
        }
        while (i < 0xffff) {
            array += "0,";
            i += 1;
            if (i % entriesPerLine === 0 && i !== 0)
                array += "\n";
        }
        if (i === 0xffff)
            array += "0";
        array += "\n};\n\n";
        arrays += array;
    }

    // Generate createFunction:
    var fn = "CharacterClass* " + name + "Create()\n{\n";
    if (emitTables && classes.UseTable) {
        if ("Inverse" in classes)
            fn += "    CharacterClass* characterClass = new CharacterClass(_" + classes.Inverse + "Data, true);\n";
        else
            fn += "    CharacterClass* characterClass = new CharacterClass(_" + name + "Data, false);\n";
    } else {
        fn += "    CharacterClass* characterClass = new CharacterClass;\n";
    }
    for (var r in ranges) {
        var min = ranges[r][0];
        var max = ranges[r][1];
        if (min === max) {
            if (min > 127)
                fn += "    characterClass->m_matchesUnicode.append(0x" + zeroPad(min.toString(16), 4) + ");\n";
            else
                fn += "    characterClass->m_matches.append(0x" + zeroPad(min.toString(16), 2) + ");\n";
            continue;
        }
        if (min > 127 || max > 127)
            fn += "    characterClass->m_rangesUnicode.append(CharacterRange(0x" + zeroPad(min.toString(16), 4) + ", 0x" + zeroPad(max.toString(16), 4) + "));\n";
        else
            fn += "    characterClass->m_ranges.append(CharacterRange(0x" + zeroPad(min.toString(16), 2) + ", 0x" + zeroPad(max.toString(16), 2) + "));\n";
    }
    fn += "    return characterClass;\n";
    fn += "}\n\n";
    functions += fn;
}

// For running with node.js
if (typeof module !== 'undefined' && module.exports)
    module.exports = { arrays: arrays, functions: functions };
