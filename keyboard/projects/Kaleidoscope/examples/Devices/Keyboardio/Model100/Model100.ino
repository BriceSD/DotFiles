// -*- mode: c++ -*-
// Copyright 2016-2022 Keyboardio, inc. <jesse@keyboard.io>
// See "LICENSE" for license details

/**
 * These #include directives pull in the Kaleidoscope firmware core,
 * as well as the Kaleidoscope plugins we use in the Model 100's firmware
 */

#include "Kaleidoscope.h"
#include "Kaleidoscope-EEPROM-Settings.h"
#include "Kaleidoscope-EEPROM-Keymap.h"
#include "Kaleidoscope-FocusSerial.h"
#include "Kaleidoscope-FirmwareVersion.h"
#include "Kaleidoscope-MouseKeys.h"
#include "Kaleidoscope-Macros.h"

#include <Kaleidoscope-HostOS.h>
#include <Kaleidoscope-Unicode.h>
#include "Kaleidoscope-LEDControl.h"
#include "Kaleidoscope-NumPad.h"
#include "Kaleidoscope-LEDEffect-BootGreeting.h"
#include "Kaleidoscope-LEDEffect-SolidColor.h"
#include "Kaleidoscope-LEDEffect-Breathe.h"
#include "Kaleidoscope-LEDEffect-Chase.h"
#include "Kaleidoscope-LEDEffect-Rainbow.h"
#include "Kaleidoscope-LED-Stalker.h"
#include "Kaleidoscope-LED-AlphaSquare.h"
#include "Kaleidoscope-LED-Palette-Theme.h"
#include "Kaleidoscope-Colormap.h"
#include "Kaleidoscope-IdleLEDs.h"
#include "Kaleidoscope-DefaultLEDModeConfig.h"
#include "Kaleidoscope-HardwareTestMode.h"
#include "Kaleidoscope-HostPowerManagement.h"
#include "Kaleidoscope-MagicCombo.h"
#include "Kaleidoscope-USB-Quirks.h"
#include "Kaleidoscope-Qukeys.h"
#include "Kaleidoscope-OneShot.h"
#include "Kaleidoscope-Escape-OneShot.h"
#include "Kaleidoscope-DynamicMacros.h"
#include "Kaleidoscope-SpaceCadet.h"
#include <Kaleidoscope-ShapeShifter.h>
#include "Kaleidoscope-LayerNames.h"
#include "Kaleidoscope-Steno.h"

/** This 'enum' is a list of all the macros used by the Model 100's firmware
  * The names aren't particularly important. What is important is that each
  * is unique.
  *
  * These are the names of your macros. They'll be used in two places.
  * The first is in your keymap definitions. There, you'll use the syntax
  * `M(MACRO_NAME)` to mark a specific keymap position as triggering `MACRO_NAME`
  *
  * The second usage is in the 'switch' statement in the `macroAction` function.
  * That switch statement actually runs the code associated with a macro when
  * a macro key is pressed.
  */

// ShiftBlocker plugin
namespace kaleidoscope {
namespace plugin {

// When activated, this plugin will suppress any `Shift` key (including modifier
// combos with `Shift`) before it's added to the HID report.
class ShiftBlocker : public Plugin {
public:
    EventHandlerResult onAddToReport(Key key) {
        if (active_ && key.isKeyboardShift())
            return EventHandlerResult::ABORT;
        return EventHandlerResult::OK;
    }
    void enable() {
        active_ = true;
    }
    void disable() {
        active_ = false;
    }

private:
    bool active_{false};
};

} // namespace kaleidoscope
} // namespace plugin

kaleidoscope::plugin::ShiftBlocker ShiftBlocker;

enum {
    MACRO_VERSION_INFO,
    MACRO_ANY,
    VIM_WQ,
    KEY_DOT_SPACE_SHIFT,
    KEY_EACUTE,
    KEY_EGRAVE,
    KEY_COMMA,
    KEY_AGRAVE,
    KEY_DOT,
    KEY_CCEDILLA,
    KEY_CIRCUMFLEX,
    KEY_OELIG,
    KEY_AELIG,
    KEY_UGRAVE,
    KEY_TRIPLEDOT,
    KEY_OPENQUOTE,
    KEY_CLOSEQUOTE,
    KEY_APOSTROPHE,
    US_BACKTICK,
    US_BACKSLASH,
    US_SEMICOLON,
    US_COMMA,
    US_PERIOD,
    US_SLASH,
    US_MINUS,
    US_QUOTE,
};


/** The Model 100's key layouts are defined as 'keymaps'. By default, there are three
  * keymaps: The standard QWERTY keymap, the "Function layer" keymap and the "Numpad"
  * keymap.
  *
  * Each keymap is defined as a list using the 'KEYMAP_STACKED' macro, built
  * of first the left hand's layout, followed by the right hand's layout.
  *
  * Keymaps typically consist mostly of `Key_` definitions. There are many, many keys
  * defined as part of the USB HID Keyboard specification. You can find the names
  * (if not yet the explanations) for all the standard `Key_` defintions offered by
  * Kaleidoscope in these files:
  *    https://github.com/keyboardio/Kaleidoscope/blob/master/src/kaleidoscope/key_defs/keyboard.h
  *    https://github.com/keyboardio/Kaleidoscope/blob/master/src/kaleidoscope/key_defs/consumerctl.h
  *    https://github.com/keyboardio/Kaleidoscope/blob/master/src/kaleidoscope/key_defs/sysctl.h
  *    https://github.com/keyboardio/Kaleidoscope/blob/master/src/kaleidoscope/key_defs/keymaps.h
  *
  * Additional things that should be documented here include
  *   using ___ to let keypresses fall through to the previously active layer
  *   using XXX to mark a keyswitch as 'blocked' on this layer
  *   using ShiftToLayer() and LockLayer() keys to change the active keymap.
  *   keeping NUM and FN consistent and accessible on all layers
  *
  * The PROG key is special, since it is how you indicate to the board that you
  * want to flash the firmware. However, it can be remapped to a regular key.
  * When the keyboard boots, it first looks to see whether the PROG key is held
  * down; if it is, it simply awaits further flashing instructions. If it is
  * not, it continues loading the rest of the firmware and the keyboard
  * functions normally, with whatever binding you have set to PROG. More detail
  * here: https://community.keyboard.io/t/how-the-prog-key-gets-you-into-the-bootloader/506/8
  *
  * The "keymaps" data structure is a list of the keymaps compiled into the firmware.
  * The order of keymaps in the list is important, as the ShiftToLayer(#) and LockLayer(#)
  * macros switch to key layers based on this list.
  *
  *

  * A key defined as 'ShiftToLayer(FUNCTION)' will switch to FUNCTION while held.
  * Similarly, a key defined as 'LockLayer(NUMPAD)' will switch to NUMPAD when tapped.
  */

/**
  * Layers are "0-indexed" -- That is the first one is layer 0. The second one is layer 1.
  * The third one is layer 2.
  * This 'enum' lets us use names like QWERTY, FUNCTION, and NUMPAD in place of
  * the numbers 0, 1 and 2.
  *
  */

enum {
    PRIMARY,
    NUMPAD,
    FUNCTION,

};  // layers


/**
  * To change your keyboard's layout from QWERTY to DVORAK or COLEMAK, comment out the line
  *
  * #define PRIMARY_KEYMAP_QWERTY
  *
  * by changing it to
  *
  * // #define PRIMARY_KEYMAP_QWERTY
  *
  * Then uncomment the line corresponding to the layout you want to use.
  *
  */

//#define PRIMARY_KEYMAP_QWERTY
// #define PRIMARY_KEYMAP_DVORAK
// #define PRIMARY_KEYMAP_COLEMAK
#define PRIMARY_KEYMAP_CUSTOM

#define  Key_Exclamation  LSHIFT(Key_1)
#define  Key_At           LSHIFT(Key_2)
#define  Key_Hash         LSHIFT(Key_3)
#define  Key_Dollar       LSHIFT(Key_4)
#define  Key_Percent      LSHIFT(Key_5)
#define  Key_Caret        LSHIFT(Key_6)
#define  Key_And          LSHIFT(Key_7)
#define  Key_Star         LSHIFT(Key_8)
#define  Key_Plus         LSHIFT(Key_Equals)
#define  Key_DoubleQuote  LSHIFT(Key_Quote)
#define  Key_Underscore   LSHIFT(Key_Minus)
#define  Key_Colon        LSHIFT(Key_Semicolon)

#define _SPACECADET_TIMEOUT_ 225
/* This comment temporarily turns off astyle's indent enforcement
 *   so we can make the keymaps actually resemble the physical key layout better
 */
// clang-format off

KEYMAPS(

#if defined (PRIMARY_KEYMAP_QWERTY)
[PRIMARY] = KEYMAP_STACKED
    (___,          Key_1, Key_2, Key_3, Key_4, Key_5, Key_LEDEffectNext,
     Key_Backtick, Key_Q, Key_W, Key_E, Key_R, Key_T, Key_Tab,
     Key_PageUp,   Key_A, Key_S, Key_D, Key_F, Key_G,
     Key_PageDown, Key_Z, Key_X, Key_C, Key_V, Key_B, Key_Escape,
     Key_LeftControl, Key_Backspace, Key_LeftGui, Key_LeftShift,
     ShiftToLayer(FUNCTION),

     M(MACRO_ANY),  Key_6, Key_7, Key_8,     Key_9,         Key_0,         LockLayer(NUMPAD),
     Key_Enter,     Key_Y, Key_U, Key_I,     Key_O,         Key_P,         Key_Equals,
     Key_H, Key_J, Key_K,     Key_L,         Key_Semicolon, Key_Quote,
     Key_RightAlt,  Key_N, Key_M, Key_Comma, Key_Period,    Key_Slash,     Key_Minus,
     Key_RightShift, Key_LeftAlt, Key_Spacebar, Key_RightControl,
     ShiftToLayer(FUNCTION)),

#elif defined (PRIMARY_KEYMAP_DVORAK)

    [PRIMARY] = KEYMAP_STACKED
    (___,          Key_1,         Key_2,     Key_3,      Key_4, Key_5, Key_LEDEffectNext,
     Key_Backtick, Key_Quote,     Key_Comma, Key_Period, Key_P, Key_Y, Key_Tab,
     Key_PageUp,   Key_A,         Key_O,     Key_E,      Key_U, Key_I,
     Key_PageDown, Key_Semicolon, Key_Q,     Key_J,      Key_K, Key_X, Key_Escape,
     Key_LeftControl, Key_Backspace, Key_LeftGui, Key_LeftShift,
     ShiftToLayer(FUNCTION),

     M(MACRO_ANY),   Key_6, Key_7, Key_8, Key_9, Key_0, LockLayer(NUMPAD),
     Key_Enter,      Key_F, Key_G, Key_C, Key_R, Key_L, Key_Slash,
     Key_D, Key_H, Key_T, Key_N, Key_S, Key_Minus,
     Key_RightAlt,   Key_B, Key_M, Key_W, Key_V, Key_Z, Key_Equals,
     Key_RightShift, Key_LeftAlt, Key_Spacebar, Key_RightControl,
     ShiftToLayer(FUNCTION)),

#elif defined (PRIMARY_KEYMAP_COLEMAK)

    [PRIMARY] = KEYMAP_STACKED
    (___,          Key_1, Key_2, Key_3, Key_4, Key_5, Key_LEDEffectNext,
     Key_Backtick, Key_Q, Key_W, Key_F, Key_P, Key_B, Key_Tab,
     Key_PageUp,   Key_A, Key_R, Key_S, Key_T, Key_G,
     Key_PageDown, Key_Z, Key_X, Key_C, Key_D, Key_V, Key_Escape,
     Key_LeftControl, Key_Backspace, Key_LeftGui, Key_LeftShift,
     ShiftToLayer(FUNCTION),

     M(MACRO_ANY),  Key_6, Key_7, Key_8,     Key_9,         Key_0,         LockLayer(NUMPAD),
     Key_Enter,     Key_J, Key_L, Key_U,     Key_Y,         Key_Semicolon, Key_Equals,
     Key_M, Key_N, Key_E,     Key_I,         Key_O,         Key_Quote,
     Key_RightAlt,  Key_K, Key_H, Key_Comma, Key_Period,    Key_Slash,     Key_Minus,
     Key_RightShift, Key_LeftAlt, Key_Spacebar, Key_RightControl,
     ShiftToLayer(FUNCTION)),

#elif defined (PRIMARY_KEYMAP_CUSTOM)
    // Edit this keymap to make a custom layout
[PRIMARY]  =  KEYMAP_STACKED (
Key_Backtick,          Key_1,          Key_Semicolon,    Key_Dollar,       Key_4,      Key_5,             Key_LEDEffectNext,
Key_LeftParen,         Key_V,          Key_M,            Key_L,            Key_C,      Key_P,             Key_Equals,
Key_LeftBracket,       Key_S,          Key_T,            Key_R,            Key_D,      Key_Y,             
Key_LeftCurlyBracket,  Key_Z,          Key_K,            Key_Q,            Key_G,      Key_W,             Key_Tab,
Key_LeftShift,         Key_Backspace,  Key_LeftControl,  Key_LeftGui,                                     
Key_Escape,                                                                                               

Key_KeypadNumLock,     Key_Minus,      Key_7,            Key_DoubleQuote,  Key_Caret,  Key_0,             Key_Backslash,
Key_Slash,             Key_X,          Key_F,            Key_O,            Key_U,      Key_J,             Key_RightParen,
Key_Period,            Key_N,          Key_A,            Key_E,            Key_I,      Key_RightBracket,  
Key_Delete,            Key_B,          Key_H,            Key_Quote,        Key_Colon,  Key_Underscore,    Key_RightCurlyBracket,
Key_RightAlt,          Key_Enter,      Key_Spacebar,     Key_RightShift,                                  
Key_Escape                                                                                                

),                                                                                           

#else

    #error "No default keymap defined. You should make sure that you have a line like '#define PRIMARY_KEYMAP_QWERTY' in your sketch"

#endif



    [NUMPAD] =  KEYMAP_STACKED
    (___, ___, ___, ___, ___, ___, ___,
     ___, ___, ___, ___, ___, ___, ___,
     ___, ___, ___, ___, ___, ___,
     ___, ___, ___, ___, ___, ___, ___,
     ___, ___, ___, ___,
     ___,

     M(MACRO_VERSION_INFO),  ___, Key_7, Key_8,      Key_9,              Key_KeypadSubtract, ___,
     ___,                    ___, Key_4, Key_5,      Key_6,              Key_KeypadAdd,      ___,
     ___, Key_1, Key_2,      Key_3,              Key_Equals,         ___,
     ___,                    ___, Key_0, Key_Period, Key_KeypadMultiply, Key_KeypadDivide,   Key_Enter,
     ___, ___, ___, ___,
     ___),

    [FUNCTION] =  KEYMAP_STACKED
    (___,      Key_F1,           Key_F2,      Key_F3,     Key_F4,        Key_F5,           Key_CapsLock,
     Key_Tab,  ___,              Key_mouseUp, ___,        Key_mouseBtnR, Key_mouseWarpEnd, Key_mouseWarpNE,
     Key_Home, Key_mouseL,       Key_mouseDn, Key_mouseR, Key_mouseBtnL, Key_mouseWarpNW,
     Key_End,  Key_PrintScreen,  Key_Insert,  ___,        Key_mouseBtnM, Key_mouseWarpSW,  Key_mouseWarpSE,
     ___, Key_Delete, ___, ___,
     ___,

     Consumer_ScanPreviousTrack, Key_F6,                 Key_F7,                   Key_F8,                   Key_F9,          Key_F10,          Key_F11,
     Consumer_PlaySlashPause,    Consumer_ScanNextTrack, Key_LeftCurlyBracket,     Key_RightCurlyBracket,    Key_LeftBracket, Key_RightBracket, Key_F12,
     Key_LeftArrow,          Key_DownArrow,            Key_UpArrow,              Key_RightArrow,  ___,              ___,
     Key_PcApplication,          Consumer_Mute,          Consumer_VolumeDecrement, Consumer_VolumeIncrement, ___,             Key_Backslash,    Key_Pipe,
     ___, ___, Key_Enter, ___,
     ___)
) // KEYMAPS(

                             /* Re-enable astyle's indent enforcement */
                             // clang-format on

                             /** versionInfoMacro handles the 'firmware version info' macro
 *  When a key bound to the macro is pressed, this macro
 *  prints out the firmware build information as virtual keystrokes
 */

                             static void versionInfoMacro(uint8_t key_state) {
                                                          if (keyToggledOn(key_state)) {
                                                          Macros.type(PSTR("Keyboardio Model 100 - Firmware version "));
Macros.type(PSTR(KALEIDOSCOPE_FIRMWARE_VERSION));
  }
}
void change_os(uint8_t combo_index) {
    if (HostOS.os() == kaleidoscope::hostos::LINUX) {
        HostOS.os(kaleidoscope::hostos::WINDOWS);
    } else {
        HostOS.os(kaleidoscope::hostos::LINUX);
    }
}
/** anyKeyMacro is used to provide the functionality of the 'Any' key.
 *
 * When the 'any key' macro is toggled on, a random alphanumeric key is
 * selected. While the key is held, the function generates a synthetic
 * keypress event repeating that randomly selected key.
 *
 */

static void anyKeyMacro(KeyEvent &event) {
    if (keyToggledOn(event.state)) {
        event.key.setKeyCode(Key_A.getKeyCode() + (uint8_t)(millis() % 36));
        event.key.setFlags(0);
    }
}

static void unicode(uint32_t character, uint8_t keyState) {
    if (keyToggledOn(keyState)) {
        Unicode.type(character);
    }
}

bool isShiftKeyHeld() {
    for (Key key : kaleidoscope::live_keys.all()) {
        //if (key.isKeyboardShift())
        if (key == Key_LeftShift || key == Key_RightShift){
            return true;
        }
    }
    return false;
}

/** macroAction dispatches keymap events that are tied to a macro
    to that macro. It takes two uint8_t parameters.

    The first is the macro being called (the entry in the 'enum' earlier in this file).
    The second is the state of the keyswitch. You can use the keyswitch state to figure out
    if the key has just been toggled on, is currently pressed or if it's just been released.

    The 'switch' statement should have a 'case' for each entry of the macro enum.
    Each 'case' statement should call out to a function to handle the macro in question.

 */

const macro_t *macroAction(uint8_t macro_id, KeyEvent &event) {
    switch (macro_id) {

        case MACRO_VERSION_INFO:
            versionInfoMacro(event.state);
            break;

        case MACRO_ANY:
            anyKeyMacro(event);
            break;

        case VIM_WQ:
            if (keyToggledOn(event.state)) {
                return MACRO(I(15), T(Escape), D(LeftShift), T(Semicolon), U(LeftShift), T(W), T(Enter));
            }
            break;
        case KEY_DOT_SPACE_SHIFT:
            if (keyToggledOn(event.state)) {
                Macros.type(PSTR(". "));
                event.key = OSM(LeftShift);
                //return MACRO(I(15), T(Period), T(Spacebar));
            }
            break;

        case KEY_EGRAVE:
            if (keyToggledOn(event.state)) {
                if (HostOS.os() == kaleidoscope::hostos::LINUX) {
                    if (isShiftKeyHeld()) {
                        Macros.press(Key_RightAlt);
                        Macros.tap(Key_7);
                        Macros.release(Key_RightAlt);
                        return MACRO_NONE;
                    } else {
                        return MACRO(I(15), T(7));
                    }
                } else {
                    if (isShiftKeyHeld()) {
                        ShiftBlocker.enable();
                        Macros.press(Key_LeftAlt);
                        Macros.tap(Key_Keypad0);
                        Macros.tap(Key_Keypad2);
                        Macros.tap(Key_Keypad0);
                        Macros.tap(Key_Keypad0);
                        Macros.release(Key_LeftAlt);
                        ShiftBlocker.disable();
                        return MACRO_NONE;
                    } else {
                        return MACRO(I(15), T(7));
                    }
                }
            }
            break;
        case KEY_EACUTE:
            if (keyToggledOn(event.state)) {
                /*      
      if (HostOS.os() == kaleidoscope::hostos::LINUX) {
        if (isShiftKeyHeld()) {
          Macros.press(Key_RightAlt);
          Macros.tap(Key_2);
          Macros.release(Key_RightAlt);
          return MACRO_NONE;
        } else {
          return MACRO(I(15), T(2));
        }
      } else {
*/        
                if (isShiftKeyHeld()) {
                    ShiftBlocker.enable();
                    return MACRO(I(15), D(LeftAlt), T(Keypad0), T(Keypad2), T(Keypad3), T(Keypad3), U(LeftAlt));
                } else {
                    return MACRO(I(15), D(LeftAlt), T(Keypad1), T(Keypad4), T(Keypad4), U(LeftAlt));
                }
                //}
            }
            break;
        //  case KEY_COMMA:
        //    if (keyToggledOn(event.state)) {
        //      if (isShiftKeyHeld()) {
        //        ShiftBlocker.enable();
        //        Macros.tap(Key_Comma);
        //        ShiftBlocker.disable();
        //        return MACRO_NONE;
        //      } else {
        //        return MACRO(I(15), T(M));
        //      }
        //    }
        //    break;
        case KEY_AGRAVE:
            if (keyToggledOn(event.state)) {
                if (HostOS.os() == kaleidoscope::hostos::LINUX) {
                    if (isShiftKeyHeld()) {
                        Macros.press(Key_RightAlt);
                        Macros.tap(Key_0);
                        Macros.release(Key_RightAlt);
                        return MACRO_NONE;
                    } else {
                        return MACRO(I(15), T(0));
                    }
                } else {
                    if (isShiftKeyHeld()) {
                        ShiftBlocker.enable();
                        Macros.press(Key_LeftAlt);
                        Macros.tap(Key_Keypad0);
                        Macros.tap(Key_Keypad1);
                        Macros.tap(Key_Keypad9);
                        Macros.tap(Key_Keypad2);
                        Macros.release(Key_LeftAlt);
                        ShiftBlocker.disable();
                        return MACRO_NONE;
                    } else {
                        return MACRO(I(15), T(0));
                    }
                }
            }
            break;
        case KEY_DOT:
            if (keyToggledOn(event.state)) {
                if (isShiftKeyHeld()) {
                    ShiftBlocker.enable();
                    Macros.tap(Key_Period);
                    ShiftBlocker.disable();
                    return MACRO_NONE;
                } else {
                    return MACRO(I(15), D(LeftShift), T(Comma), U(LeftShift));
                }
            }
            break;
        case KEY_CCEDILLA:
            if (keyToggledOn(event.state)) {
                if (HostOS.os() == kaleidoscope::hostos::LINUX) {
                    if (isShiftKeyHeld()) {
                        Macros.press(Key_RightAlt);
                        Macros.tap(Key_9);
                        Macros.release(Key_RightAlt);
                        return MACRO_NONE;
                    } else {
                        return MACRO(I(15), T(9));
                    }
                } else {
                    if (isShiftKeyHeld()) {
                        ShiftBlocker.enable();
                        Macros.press(Key_LeftAlt);
                        Macros.tap(Key_Keypad0);
                        Macros.tap(Key_Keypad1);
                        Macros.tap(Key_Keypad9);
                        Macros.tap(Key_Keypad9);
                        Macros.release(Key_LeftAlt);
                        ShiftBlocker.disable();
                        return MACRO_NONE;
                    } else {
                        return MACRO(I(15), T(9));
                    }
                }
            }
            break;
        //  case KEY_CIRCUMFLEX:
        //    if (keyToggledOn(event.state)) {
        //      if (isShiftKeyHeld()) {
        //        ShiftBlocker.enable();
        //        Macros.tap(Key_Slash);
        //        ShiftBlocker.disable();
        //        return MACRO_NONE;
        //      } else {
        //        return MACRO(T(LeftBracket));
        //      }
        //    }
        //    break;
        case KEY_OELIG:
            if (keyToggledOn(event.state)) {
                if (HostOS.os() == kaleidoscope::hostos::LINUX) {
                    return MACRO(I(15), D(RightAlt), T(O), U(RightAlt));
                } else {
                    if (isShiftKeyHeld()) {
                        ShiftBlocker.enable();
                        Macros.press(Key_LeftAlt);
                        Macros.tap(Key_Keypad0);
                        Macros.tap(Key_Keypad1);
                        Macros.tap(Key_Keypad4);
                        Macros.tap(Key_Keypad0);
                        Macros.release(Key_LeftAlt);
                        ShiftBlocker.disable();
                        return MACRO_NONE;
                    } else {
                        return MACRO(I(15), D(LeftAlt), T(Keypad0), T(Keypad1), T(Keypad5), T(Keypad6), U(LeftAlt));
                    }
                }
            }
            break;
        case KEY_AELIG:
            if (keyToggledOn(event.state)) {
                if (HostOS.os() == kaleidoscope::hostos::LINUX) {
                    return MACRO(I(15), D(RightAlt), T(Q), U(RightAlt));
                } else {
                    if (isShiftKeyHeld()) {
                        ShiftBlocker.enable();
                        Macros.press(Key_LeftAlt);
                        Macros.tap(Key_Keypad1);
                        Macros.tap(Key_Keypad4);
                        Macros.tap(Key_Keypad6);
                        Macros.release(Key_LeftAlt);
                        ShiftBlocker.disable();
                        return MACRO_NONE;
                    } else {
                        return MACRO(I(15), D(LeftAlt), T(Keypad1), T(Keypad4), T(Keypad5), U(LeftAlt));
                    }
                }
            }
            break;
        case KEY_UGRAVE:
            if (keyToggledOn(event.state)) {
                if (HostOS.os() == kaleidoscope::hostos::LINUX) {
                    if (isShiftKeyHeld()) {
                        return MACRO(I(15), D(RightAlt), T(Quote), U(RightAlt));
                    } else {
                        return MACRO(I(15), T(Quote));
                    }
                } else {
                    if (isShiftKeyHeld()) {
                        ShiftBlocker.enable();
                        Macros.press(Key_LeftAlt);
                        Macros.tap(Key_Keypad0);
                        Macros.tap(Key_Keypad2);
                        Macros.tap(Key_Keypad1);
Macros.tap(Key_Keypad7);
                        Macros.release(Key_LeftAlt);
                        ShiftBlocker.disable();
                        return MACRO_NONE;
                    } else {
                        return MACRO(I(15), T(Quote));
                    }
                }
            }
            break;
        case KEY_TRIPLEDOT:
            if (keyToggledOn(event.state)) {
                if (HostOS.os() == kaleidoscope::hostos::LINUX) {
                    return MACRO(I(15), D(LeftShift), D(RightAlt), T(M), U(RightAlt), U(LeftShift));
                } else {
                    return MACRO(I(15), D(LeftAlt), T(Keypad0), T(Keypad1), T(Keypad3), T(Keypad3), U(LeftAlt));
                }
            }
            break;
        case KEY_APOSTROPHE:
            if (keyToggledOn(event.state)) {
                if (HostOS.os() == kaleidoscope::hostos::LINUX) {
                    if (isShiftKeyHeld()) {
                        return MACRO(I(15), T(M));
                    } else {
                        return MACRO(I(15), D(RightAlt), T(G), U(RightAlt));
                    }
                } else {
                    if (isShiftKeyHeld()) {
                        return MACRO(I(15), T(M));
                    } else {
                        return MACRO(I(15), D(LeftAlt), T(Keypad0), T(Keypad1), T(Keypad4), T(Keypad6), U(LeftAlt));
                    }
                }
            }
            break;
        case KEY_OPENQUOTE:
            if (keyToggledOn(event.state)) {
                if (HostOS.os() == kaleidoscope::hostos::LINUX) {
                    return MACRO(I(15), D(RightAlt), T(Z), U(RightAlt));
                } else {
                    return MACRO(I(15), D(LeftAlt), T(Keypad1), T(Keypad7), T(Keypad4), U(LeftAlt));
                }
            }
            break;
        case KEY_CLOSEQUOTE:
            if (keyToggledOn(event.state)) {
                if (HostOS.os() == kaleidoscope::hostos::LINUX) {
                    return MACRO(I(15), D(RightAlt), T(X), U(RightAlt));
                } else {
                    return MACRO(I(15), D(LeftAlt),  T(Keypad1), T(Keypad7), T(Keypad5), U(LeftAlt));
                }
            }
            break;
        /*
  case US_BACKTICK:
    if (keyToggledOn(event.state)) {
      if (isShiftKeyHeld()) {
        ShiftBlocker.enable();
        Macros.tap(Fr_Tilde);
        ShiftBlocker.disable();
        return MACRO_NONE;
      } else {
        return MACRO(I(15), Tr(Fr_Backtick));
      }
    }
    break;
    */
        /*    
  case US_BACKSLASH:
    if (keyToggledOn(event.state)) {
      if (isShiftKeyHeld()) {
        ShiftBlocker.enable();
        Macros.tap(Fr_Pipe);
        ShiftBlocker.disable();
        return MACRO_NONE;
      } else {
        return MACRO(I(15), Tr(Fr_Backslash));
      }
    }
    break;
  case US_SEMICOLON:
    if (keyToggledOn(event.state)) {
      if (isShiftKeyHeld()) {
        ShiftBlocker.enable();
        Macros.tap(Fr_Colon);
        ShiftBlocker.disable();
        return MACRO_NONE;
      } else {
        return MACRO(I(15), Tr(Fr_Semicolon));
      }
    }
    break;
  case US_COMMA:
    if (keyToggledOn(event.state)) {
      if (isShiftKeyHeld()) {
        ShiftBlocker.enable();
        Macros.tap(Fr_LessThan);
        ShiftBlocker.disable();
        return MACRO_NONE;
      } else {
        return MACRO(I(15), Tr(Fr_Comma));
      }
    }
    break;
  case US_PERIOD:
    if (keyToggledOn(event.state)) {
      if (isShiftKeyHeld()) {
        ShiftBlocker.enable();
        Macros.tap(Fr_GreaterThan);
        ShiftBlocker.disable();
        return MACRO_NONE;
      } else {
        return MACRO(I(15), Tr(Fr_Period));
      }
    }
    break;
  case US_SLASH:
    if (keyToggledOn(event.state)) {
      if (isShiftKeyHeld()) {
        ShiftBlocker.enable();
        Macros.tap(Fr_QuestionMark);
        ShiftBlocker.disable();
        return MACRO_NONE;
      } else {
        return MACRO(I(15), Tr(Fr_Slash));
      }
    }
    break;
  case US_MINUS:
    if (keyToggledOn(event.state)) {
      if (isShiftKeyHeld()) {
        ShiftBlocker.enable();
        Macros.tap(Fr_Underscore);
        ShiftBlocker.disable();
        return MACRO_NONE;
      } else {
        return MACRO(I(15), Tr(Fr_Minus));
      }
    }
    break;
  case US_QUOTE:
    if (keyToggledOn(event.state)) {
      if (isShiftKeyHeld()) {
        ShiftBlocker.enable();
        Macros.tap(Fr_DoubleQuote);
        ShiftBlocker.disable();
        return MACRO_NONE;
      } else {
        return MACRO(I(15), Tr(Fr_Quote));
      }
    }
    break;
*/    
        default:
            break;
    }
    return MACRO_NONE;
}


// These 'solid' color effect definitions define a rainbow of
// LED color modes calibrated to draw 500mA or less on the
// Keyboardio Model 100.


static kaleidoscope::plugin::LEDSolidColor solidRed(160, 0, 0);
static kaleidoscope::plugin::LEDSolidColor solidOrange(140, 70, 0);
static kaleidoscope::plugin::LEDSolidColor solidYellow(130, 100, 0);
static kaleidoscope::plugin::LEDSolidColor solidGreen(0, 160, 0);
static kaleidoscope::plugin::LEDSolidColor solidBlue(0, 70, 130);
static kaleidoscope::plugin::LEDSolidColor solidIndigo(0, 0, 170);
static kaleidoscope::plugin::LEDSolidColor solidViolet(130, 0, 120);

/** toggleLedsOnSuspendResume toggles the LEDs off when the host goes to sleep,
 * and turns them back on when it wakes up.
 */
void toggleLedsOnSuspendResume(kaleidoscope::plugin::HostPowerManagement::Event event) {
    switch (event) {
        case kaleidoscope::plugin::HostPowerManagement::Suspend:
            LEDControl.disable();
            break;
        case kaleidoscope::plugin::HostPowerManagement::Resume:
            LEDControl.enable();
            break;
        case kaleidoscope::plugin::HostPowerManagement::Sleep:
            break;
    }
}

/** hostPowerManagementEventHandler dispatches power management events (suspend,
 * resume, and sleep) to other functions that perform action based on these
 * events.
 */
void hostPowerManagementEventHandler(kaleidoscope::plugin::HostPowerManagement::Event event) {
    toggleLedsOnSuspendResume(event);
}

/** This 'enum' is a list of all the magic combos used by the Model 100's
 * firmware The names aren't particularly important. What is important is that
 * each is unique.
 *
 * These are the names of your magic combos. They will be used by the
 * `USE_MAGIC_COMBOS` call below.
 */
enum {
    // Toggle between Boot (6-key rollover; for BIOSes and early boot) and NKRO
    // mode.
    COMBO_TOGGLE_NKRO_MODE,
    // Enter test mode
    COMBO_ENTER_TEST_MODE,
    COMBO_PRESS_ESCAPE_LEFT,
    COMBO_PRESS_ESCAPE_RIGHT
};

/** Wrappers, to be used by MagicCombo. **/
void comboPressEscape(uint8_t combo_index) {
    Macros.tap(Key_Escape);
}

/**
 * This simply toggles the keyboard protocol via USBQuirks, and wraps it within
 * a function with an unused argument, to match what MagicCombo expects.
 */
static void toggleKeyboardProtocol(uint8_t combo_index) {
    USBQuirks.toggleKeyboardProtocol();
}

/**
 * Toggles between using the built-in keymap, and the EEPROM-stored one.
 */
static void toggleKeymapSource(uint8_t combo_index) {
    if (Layer.getKey == Layer.getKeyFromPROGMEM) {
Layer.getKey = EEPROMKeymap.getKey;
    } else {
        Layer.getKey = Layer.getKeyFromPROGMEM;
    }
}

/**
 *  This enters the hardware test mode
 */
static void enterHardwareTestMode(uint8_t combo_index) {
    HardwareTestMode.runTests();
}


/** Magic combo list, a list of key combo and action pairs the firmware should
 * recognise.
 */
USE_MAGIC_COMBOS(
    {
        .action = toggleKeyboardProtocol,
        // Left Fn + Esc + Shift
        .keys = {R3C6, R2C6, R3C7}
    },
    {
        .action = enterHardwareTestMode,
        // Left Fn + Prog + LED
        .keys = {R3C6, R0C0, R0C6}
    },
    // {
    //     .action = toggleKeymapSource,
    //     // Left Fn + Prog + Shift
    //     .keys = {R3C6, R0C0, R3C7}
    // },
    // {
    //     .action = comboPressEscape, 
    //     .keys = {R1C2, R1C3}
    // },
    // {
    //     .action = comboPressEscape, 
    //     .keys = {R1C12, R1C13}
    // }

);


// First, tell Kaleidoscope which plugins you want to use.
// The order can be important. For example, LED effects are
// added in the order they're listed here.
KALEIDOSCOPE_INIT_PLUGINS(
    // The EEPROMSettings & EEPROMKeymap plugins make it possible to have an
    // editable keymap in EEPROM.
    EEPROMSettings,
    EEPROMKeymap,

    // The Qukeys plugin enables the "Secondary action" functionality in
    // Chrysalis. Keys with secondary actions will have their primary action
    // performed when tapped, but the secondary action when held.
    Qukeys,

    // SpaceCadet can turn your shifts into parens on tap, while keeping them as
    // Shifts when held. SpaceCadetConfig lets Chrysalis configure some aspects of
    // the plugin.
    SpaceCadet,
    SpaceCadetConfig,

    // Remap a shift to an other shift
    ShapeShifter,

    // Focus allows bi-directional communication with the host, and is the
    // interface through which the keymap in EEPROM can be edited.
    Focus,

    // FocusSettingsCommand adds a few Focus commands, intended to aid in
    // changing some settings of the keyboard, such as the default layer (via the
    // `settings.defaultLayer` command)
FocusSettingsCommand,

    // FocusEEPROMCommand adds a set of Focus commands, which are very helpful in
    // both debugging, and in backing up one's EEPROM contents.
    FocusEEPROMCommand,

    // The boot greeting effect pulses the LED button for 10 seconds after the
    // keyboard is first connected
    BootGreetingEffect,

    // The hardware test mode, which can be invoked by tapping Prog, LED and the
    // left Fn button at the same time.
    HardwareTestMode,

// LEDControl provides support for other LED modes
    LEDControl,

    // We start with the LED effect that turns off all the LEDs.
    LEDOff,

    // The rainbow effect changes the color of all of the keyboard's keys at the same time
    // running through all the colors of the rainbow.
    LEDRainbowEffect,

    // The rainbow wave effect lights up your keyboard with all the colors of a rainbow
    // and slowly moves the rainbow across your keyboard
    LEDRainbowWaveEffect,

    // The chase effect follows the adventure of a blue pixel which chases a red pixel across
    // your keyboard. Spoiler: the blue pixel never catches the red pixel
    LEDChaseEffect,

    // These static effects turn your keyboard's LEDs a variety of colors
    solidRed,
    solidOrange,
    solidYellow,
    solidGreen,
    solidBlue,
    solidIndigo,
    solidViolet,

    // The breathe effect slowly pulses all of the LEDs on your keyboard
    LEDBreatheEffect,

    // The AlphaSquare effect prints each character you type, using your
    // keyboard's LEDs as a display
    AlphaSquareEffect,

    // The stalker effect lights up the keys you've pressed recently
    StalkerEffect,

    // The LED Palette Theme plugin provides a shared palette for other plugins,
    // like Colormap below
    LEDPaletteTheme,

    // The Colormap effect makes it possible to set up per-layer colormaps
    ColormapEffect,

    // The numpad plugin is responsible for lighting up the 'numpad' mode
    // with a custom LED effect
NumPad,

    // The macros plugin adds support for macros
    Macros,
    HostOS,
    Unicode,  

    // The MouseKeys plugin lets you add keys to your keymap which move the mouse.
    MouseKeys,

    // The HostPowerManagement plugin allows us to turn LEDs off when then host
    // goes to sleep, and resume them when it wakes up.
    HostPowerManagement,

    // The MagicCombo plugin lets you use key combinations to trigger custom
    // actions - a bit like Macros, but triggered by pressing multiple keys at the
    // same time.
    MagicCombo,

// The USBQuirks plugin lets you do some things with USB that we aren't
    // comfortable - or able - to do automatically, but can be useful
    // nevertheless. Such as toggling the key report protocol between Boot (used
    // by BIOSes) and Report (NKRO).
    USBQuirks,

    // Enables the "Sticky" behavior for modifiers, and the "Layer shift when
    // held" functionality for layer keys.
    OneShot,
    EscapeOneShot,
    EscapeOneShotConfig,

    // Turns LEDs off after a configurable amount of idle time.
    IdleLEDs,
    PersistentIdleLEDs,

    // Enables dynamic, Chrysalis-editable macros.
    DynamicMacros,

    // The FirmwareVersion plugin lets Chrysalis query the version of the firmware
    // programmatically.
    FirmwareVersion,

    // The LayerNames plugin allows Chrysalis to display - and edit - custom layer
    // names, to be shown instead of the default indexes.
    LayerNames,

    // Enables setting, saving (via Chrysalis), and restoring (on boot) the
    // default LED mode.
    DefaultLEDModeConfig,

    // Enables the GeminiPR Stenography protocol. Unused by default, but with the
    // plugin enabled, it becomes configurable - and then usable - via Chrysalis.
GeminiPR);





/** The 'setup' function is one of the two standard Arduino sketch functions.
 * It's called when your keyboard first powers up. This is where you set up
 * Kaleidoscope and any plugins.
 */
void setup() {
    // The following Qukey definitions are for the left side of the home row (and
    // the left palm key) of the Keyboardio Model01 keyboard.  For other
    // keyboards, the `KeyAddr(row, col)` coordinates will need adjustment.
    QUKEYS(
        //https://kaleidoscope.readthedocs.io/en/stable/plugins/Kaleidoscope-Qukeys.html
        // Left hand
        // UP Row
        // kaleidoscope::plugin::Qukey(0, KeyAddr(1, 3), Key_LeftControl),  // Middle UP
        // kaleidoscope::plugin::Qukey(0, KeyAddr(1, 2), Key_LeftAlt),  // Ring UP
        // // Home Row
        // kaleidoscope::plugin::Qukey(0, KeyAddr(2, 1), Key_LeftAlt),      // Pinky HOME
        // kaleidoscope::plugin::Qukey(0, KeyAddr(2, 2), ShiftToLayer(4)),      // Ring HOME
        // kaleidoscope::plugin::Qukey(0, KeyAddr(2, 3), Key_LeftControl),  // Middle HOME
        // kaleidoscope::plugin::Qukey(0, KeyAddr(2, 4), ShiftToLayer(3)),  // Index HOME
        // //Down Row
        kaleidoscope::plugin::Qukey(0, KeyAddr(2, 0), M(VIM_WQ)),
        // kaleidoscope::plugin::Qukey(0, KeyAddr(3, 4), ShiftToLayer(5)),   // Index DOWN
        // // Mod Row 
        // kaleidoscope::plugin::Qukey(0, KeyAddr(1, 7), Key_LeftControl),   // Thumb Second Leftmost
        // kaleidoscope::plugin::Qukey(0, KeyAddr(2, 7), M(KEY_DOT_SPACE_SHIFT)),   // Thumb Leftmost
        //
        // // Right hand
        // // UP Row
        // kaleidoscope::plugin::Qukey(0, KeyAddr(1, 12), Key_LeftControl),  // Middle UP
        // kaleidoscope::plugin::Qukey(0, KeyAddr(1, 13), Key_LeftAlt),  // Ring UP
        //
        // // Home Row
        // kaleidoscope::plugin::Qukey(0, KeyAddr(2, 11), ShiftToLayer(3)),  // Index HOME
        // kaleidoscope::plugin::Qukey(0, KeyAddr(2, 12), Key_LeftControl),  // Middle HOME
        // kaleidoscope::plugin::Qukey(0, KeyAddr(2, 13), ShiftToLayer(4)),      // Ring HOME
        // kaleidoscope::plugin::Qukey(0, KeyAddr(2, 14), Key_LeftAlt),      // Pinky HOME
        // // Down Row
        // kaleidoscope::plugin::Qukey(0, KeyAddr(3, 11), ShiftToLayer(5)),   // Index DOWN
        //  kaleidoscope::plugin::Qukey(0, KeyAddr(3, 13), Key_Semicolon),   // Index DOWN
        // // // Mod Row 
        // kaleidoscope::plugin::Qukey(0, KeyAddr(1, 8), Key_LeftControl),   // Thumb Rightmost
    )
    // https://kaleidoscope.readthedocs.io/en/latest/plugins/Kaleidoscope-Qukeys.html#configuration
    // Sets the time (in milliseconds) after which a qukey held on its own will take on its alternate state. 
    // Note: this is not the primary determining factor for a qukey’s state. 
    // It is not necessary to wait this long before pressing a key that should be modified by the qukey’s alternate value.
    // The primary function of this timeout is so that a qukey can be used as a modifier for an separate pointing device (i.e. shift + click).
    // Defaults to 250.
    Qukeys.setHoldTimeout(200);
    Qukeys.setOverlapThreshold(100);
    // Sets the minimum amount of time (in milliseconds) a qukey must be held before it is allowed to resolve 
    // to its alternate Key value. Use this if you find that you’re getting unintended alternate values (i.e. modifiers) 
    // while typing on home-row qukeys, despite setting the overlap threshold (see above) to 100%. 
    // It may mean that you’ll need to slow down when using Qukeys to get modifiers, however.
    // Defaults to 50 (milliseconds).
    Qukeys.setMinimumHoldTime(150);
    // Sets the minimum amount of time (in milliseconds) that must pass between the press event of a prior (non-modifier) key 
    // and the press of a qukey required to make that qukey eligible to take on it’s alternate state. 
    // This is another measure that can be taken to prevent unintended modifiers while typing fast.
    // Defaults to 75 (milliseconds).
    Qukeys.setMinimumPriorInterval(100);
    Qukeys.setMaxIntervalForTapRepeat(0);

    // First, call Kaleidoscope's internal setup function
    Kaleidoscope.setup();

    // Set the hue of the boot greeting effect to something that will result in a
    // nice green color.
    BootGreetingEffect.hue = 85;

    // While we hope to improve this in the future, the NumPad plugin
    // needs to be explicitly told which keymap layer is your numpad layer
    NumPad.numPadLayer = NUMPAD;

    // We configure the AlphaSquare effect to use RED letters
    AlphaSquare.color = CRGB(255, 0, 0);

    // We set the brightness of the rainbow effects to 150 (on a scale of 0-255)
    // This draws more than 500mA, but looks much nicer than a dimmer effect
    LEDRainbowEffect.brightness(255);
    LEDRainbowWaveEffect.brightness(255);

    // Set the action key the test mode should listen for to Left Fn
    HardwareTestMode.setActionKey(R3C6);

    // The LED Stalker mode has a few effects. The one we like is called
    // 'BlazingTrail'. For details on other options, see
    // https://github.com/keyboardio/Kaleidoscope/blob/master/docs/plugins/LED-Stalker.md
    StalkerEffect.variant = STALKER(BlazingTrail);

    // To make the keymap editable without flashing new firmware, we store
    // additional layers in EEPROM. For now, we reserve space for eight layers. If
    // one wants to use these layers, just set the default layer to one in EEPROM,
    // by using the `settings.defaultLayer` Focus command, or by using the
    // `keymap.onlyCustom` command to use EEPROM layers only.
    EEPROMKeymap.setup(8);

    // We need to tell the Colormap plugin how many layers we want to have custom
    // maps for. To make things simple, we set it to eight layers, which is how
    // many editable layers we have (see above).
    ColormapEffect.max_layers(8);

    // For Dynamic Macros, we need to reserve storage space for the editable
    // macros. A kilobyte is a reasonable default.
    DynamicMacros.reserve_storage(1024);

    // If there's a default layer set in EEPROM, we should set that as the default
    // here.
    Layer.move(EEPROMSettings.default_layer());

    // To avoid any surprises, SpaceCadet is turned off by default. However, it
    // can be permanently enabled via Chrysalis, so we should only disable it if
    // no configuration exists.
    SpaceCadetConfig.disableSpaceCadetIfUnconfigured();

    // Editable layer names are stored in EEPROM too, and we reserve 16 bytes per
    // layer for them. We need one extra byte per layer for bookkeeping, so we
    // reserve 17 / layer in total.
    LayerNames.reserve_storage(17 * 8);

    // Unless configured otherwise with Chrysalis, we want to make sure that the
    // firmware starts with LED effects off. This avoids over-taxing devices that
    // don't have a lot of power to share with USB devices
    DefaultLEDModeConfig.activateLEDModeIfUnconfigured(&LEDOff);
}

/** loop is the second of the standard Arduino sketch functions.
  * As you might expect, it runs in a loop, never exiting.
  *
  * For Kaleidoscope-based keyboard firmware, you usually just want to
  * call Kaleidoscope.loop(); and not do anything custom here.
  */

void loop() {
    Kaleidoscope.loop();
}
