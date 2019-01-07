![ls](image/ls.jpg)

## Overview

- `icons-in-terminal` allows you to get any fonts in your terminal without replacing or patching your font.  
- You can add as many fonts as you want easily, you just need the ttf/odf file and add it to `config.json`.  
- `icons-in-terminal` can also be use with graphical applications.  

## Table of Contents

1. [**Installation**](#installation)  
2. [**Building**](#building)  
3. [**How it works**](#how-it-works)  
4. [**Included icons**](#included-icons)  
5. [**Screenshots**](#screenshots)  
6. [**Integrations**](#integrations)  
    * [**fish-shell**](#fish-integration)  
    * [**bash**](#bash-integration)  
    * [**emacs**](#emacs-integration)  
7. [**Projects using icons-in-terminal**](#projects-using-icons-in-terminal)  
    * [**ls**](#ls)  
    * [**emacs**](#emacs)  
8. [**Todos**](#todos)  

## Installation

Make sure you have `fontconfig installed`. You can check this by running:
```bash
fc-conflist
```
If you don't have it then install it with whatever package manager you're using on your system.

Clone the `icons-in-terminal` git repository somewhere
```bash
$ git clone https://github.com/sebastiencs/icons-in-terminal.git
```
> NB: All future installation instructions assume you have changed into the cloned directory.

### Experimental Install

If your terminal is [supported](https://github.com/sebastiencs/icons-in-terminal/issues/1) (OS X's Terminal or the iTerm application are _not_), run:__
```bash
$ ./install-autodetect.sh 
```

### Standard Install
To install, run:  
```bash
$ ./install.sh  
```
> Follow the instructions to edit ~/.config/fontconfig/conf.d/30-icons.conf

#### OS X Additional Installation

There are two additional steps you need to perform on OS X. First you need to add the TrueType Font file to FontBook. The second is to modifiy the default system font list file to include the icons-in-terminal font. Please note that you will need XCode installed to perform the second step as you will need it to edit a binary plist file.

> Note: These instructions were copied from https://github.com/gabrielelana/awesome-terminal-fonts/wiki/OS-X after information from @amoriello and @sebastiencs (see [here](https://github.com/sebastiencs/icons-in-terminal/issues/1#issuecomment-320480809))

##### Install icons-in-terminal in FontBook

To install the icons in FontBook, run:
```bash
open build/icons-in-terminal.ttf
```
and then click the 'Install Font' button. You can then close FontBook if you like.

##### Add icons-in-terminal to the default font list

###### Disable System Integrity Protection

Reboot your mac and hold <kbd>CMD+R</kbd> after the startup chime.

Launch Terminal.app from the Utilities menu once booted into System Recovery and run:

```bash
csrutil disable; reboot
```

###### Edit the default font list

Once rebooted back into normal mode, use Xcode.app to open and edit the `DefaultFontFallbacks.plist` file.

First, make a backup:
```bash
sudo cp /System/Library/Frameworks/ApplicationServices.framework/Frameworks/CoreText.framework/Resources/DefaultFontFallbacks.plist /System/Library/Frameworks/ApplicationServices.framework/Frameworks/CoreText.framework/Resources/DefaultFontFallbacks.plist.ORIG
```
Copy the file to a non-super-user-accessble directory:
```bash
cp /System/Library/Frameworks/ApplicationServices.framework/Frameworks/CoreText.framework/Resources/DefaultFontFallbacks.plist /tmp
```
Edit the plist:
```bash
open -a Xcode.app /tmp/DefaultFontFallbacks.plist
```
In the plist editor, expand "monospace" then hover off the "monospace" row and click the <kbd>+</kbd> icon to add a new row and change the value to `icons-in-terminal`. Save and exit XCode.

Overwrite `DefaultFontFallbacks.plist`:
```bash
sudo mv /tmp/DefaultFontFallbacks.plist /System/Library/Frameworks/ApplicationServices.framework/Frameworks/CoreText.framework/Resources/DefaultFontFallbacks.plist
```

###### Re-Enable System Integrity Protection

Now reboot into recovery mode again (<kbd>CMD+R</kbd>) and re-enable System Integrity Protection:

```bash
csrutil enable; reboot
```

### Checking installation

You can start a new terminal and run `print_icons.sh` to see the installed glyphs.  
You can see names of each icon by giving any parameter to `print_icons.sh`:  
```bash
$ ./print_icons.sh
$ ./print_icons.sh --names
$ ./print_icons.sh --names | grep ANY_NAME
```
To use icons in your terminal, **do not copy-paste icons** from the output of `print_icons.sh` but use their variable name: see [integrations](#integrations).  
When one of the provided font will be updated and add new icons, some codepoints in `icons-in-terminal.ttf` will be changed, the variable names won't.  


## Building

If you want to add new font, follow these instructions:  

There are a few dependencies to install:  

- Python 3
- [fontforge (with python extension)](https://fontforge.github.io)

You can add the name and path of your font to the file `config.json`.  
Each font can take parameters:  
- `start-from`: exclude all glyphes before the given codepoint.
- `until`: exclude all glyphes at the given codepoint and after.
- `excludes`: exclude the given codepoints.
- `move-vertically`: Use this parameter if your font and its glyphes are not centered vertically.
- `short-name`: Prefix to insert before the glyph name when you want to use the icon in your shell or anywhere else
- `map-names`: Define a name to the glyph. If not provided, the name will be read from the ttf file

Once done, you can run:  
```bash
$ ./build.sh
```
## How it works

This project is inspired by [awesome-terminal-fonts](https://github.com/gabrielelana/awesome-terminal-fonts) but is different.  
I don't modify any existing font, I merge all glyphes from the provided fonts in a new font file and insert them in the [private use areas](https://en.wikipedia.org/wiki/Private_Use_Areas).  
The file `~/.config/fontconfig/conf.d/30-icons.conf` tells to freetype to search the glyph in `icons-in-terminal.ttf` if it fails in your default font file. As the codepoints generated are in the private use areas, freetype should always fail and fallback to icons-in-terminal.ttf  
The only requirement is that your default font shouldn't be already patched/modified. But why use a patched font with a limited number of glyphes when they are all included here :)  
Your terminal emulator should also support [fallback font](https://en.wikipedia.org/wiki/Fallback_font) (most of them support it)  

## Included icons

There are already 3618 glyphes included:  

| Name                                                                             | Version        | Notes |
| ---------------------------------------------------------------------------------|---------------:|--------|
| [powerline-extra-symbols](https://github.com/ryanoasis/powerline-extra-symbols)  | commit 4eae6e8 | |
| [octicons](https://octicons.github.com/)                                         | 4.4.0          | |
| [fontawesome](http://fontawesome.io/)                                            | 4.7            | |
| [material-design-icons](https://github.com/google/material-design-icons)         | 3.0.1          | |
| [file-icons](https://atom.io/packages/file-icons)                                | 2.1.4          | |
| [weather-icons](https://erikflowers.github.io/weather-icons/)                    | 2.0.10         | |
| [font-linux](https://github.com/Lukas-W/font-linux)                              | 0.9            | |
| [devicons](https://github.com/vorillaz/devicons)                                 | 1.8.0          | |
| [Pomicons](https://github.com/gabrielelana/pomicons)                             | commit bb0a579 | |
| [linea](http://linea.io/)                                                        | 1.0            | |
| [font-mfizz](https://github.com/fizzed/font-mfizz)                               | 2.4.1          | |
| [FiraCode](https://github.com/tonsky/FiraCode)                                   | [1.200](https://github.com/tonsky/FiraCode/issues/211#issuecomment-239058632) | See if your terminal is [compatible](https://github.com/tonsky/FiraCode#terminal-support) |

## Screenshots

![Screenshot the included icons](image/icons.jpg)
![Screenshot with fish](image/icons-fish.jpg)

## Integrations

### Fish integration

To use `icons-in-terminal` with fish, add this line to `~/.config/fish/config.fish`:  
```bash
source ~/.local/share/icons-in-terminal/icons.fish
```
Restart a terminal, now you can print any icons with its name:  
```bash
$ echo $oct_location
```

### Bash integration

Add this line to your .bashrc:  
```bash
source ~/.local/share/icons-in-terminal/icons_bash.sh
```
Restart a terminal, now you can print any icons with its name:  
```bash
$ echo -e $oct_location # note the '-e'
```
> Note: The above only works if using bash version 4.2 or greater. ie: this won't work on some versions of OS X.

### Emacs integration

You will need to `require` both `icons-in-terminal.el` (which has been installed into `~/.local/share/icons-in-terminal`) and `font-lock+.el` which you will have to clone somewhere from [github](https://github.com/emacsmirror/font-lock-plus). (Thanks to @thomasluquet, see [here](https://github.com/sebastiencs/icons-in-terminal/pull/12/files)). For example, your emacs init file might contain:
```el
(add-to-list 'load-path "<PATH TO CLONED FONT LOCK PLUS>")
(require 'font-lock+)

(add-to-list 'load-path "~/.local/share/icons-in-terminal/")
(require 'icons-in-terminal)
```
You can try this out in emacs by opening a `*scratch*` window and running:
```el
(insert (icons-in-terminal 'oct_flame))
```
You can also get more help by executing:
```el
C-h f icons-in-terminal[RET]
```

## Projects using icons-in-terminal

### ls

https://github.com/sebastiencs/ls-icons

### emacs

https://github.com/sebastiencs/sidebar.el

## Todos

- Integrate with differents shells
