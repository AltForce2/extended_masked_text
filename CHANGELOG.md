## 3.0.0

* **BREAKING:** Remove CursorBehaviour.start
* Rename CursorBehaviour to CursorBehavior
* Rewrite part of the code to a more modern dart approach
* Fix some minor issues related to CursorBehavior.end
* Remove tests related to CursorBehaviour.start

## 2.3.2

* Adds a getter to unmasked text for MoneyMaskedTextController
* Update lint rules (also remove deprecated ones)
* Update code documentation and fix lint issues

## 2.3.1

* Remove forgotten print

## 2.3.0

* Adds improvements to cursor position calculation
* Adds a getter to unmasked text

## 2.2.1

* Adds a workaround to fix behavior from flutter 2.2

## 2.2.0

* Adds CursorBehaviour to MaskedTextController

## 2.1.0

* Adds beforeChange and afterChange to MaskedTextController

## 2.0.0+1

* Fix logo url

## 2.0.0

* Migrates to null safety
* Migrates example project to null safety
* Add logo to README.md

## 1.1.0

* Fixes an undesired behavior in which the cursor jumped to the end when trying to update the middle of the value
* Reduces the number of times the mask is updated

## 1.0.2

* Fix bug where money value jumps to 0 when erasing text

## 1.0.1

* Add link to source project to README
* Update example project
* Fix MaskedTextController bug where cursor goes to the beginning of the text

## 1.0.0

* Initial release.