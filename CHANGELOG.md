7.3.2v1.1 Release - 2017/11/19

Bug fix: Resolved the lag when learning or unlearning an appearance.

* [#120](https://gitlab.com/toreltwiddler/CanIMogIt/issues/120) Learning an appearance now only clears that item from the cache.  The cache is no longer reset every time an item is learned.

*****

7.3.2v1.0 Release - 2017/10/30

Bug fixes including preventing an error caused by Bagnon.

Tweaks to Auctioneer exception and Soulbound overlay display.

* [#62](https://gitlab.com/toreltwiddler/CanIMogIt/issues/62) Fixed Exception items not showing the overlay.
* [#63](https://gitlab.com/toreltwiddler/CanIMogIt/issues/63) Changed some exception items to show Cannot be learned instead of Learned because while they're invisible and share AppearanceID with the Hidden items, technically they cannot be learned themselves.  Added a few more exception items.
* [#103](https://gitlab.com/toreltwiddler/CanIMogIt/issues/103) Fixed old work-around with Tabard assignment.
* [#129](https://gitlab.com/toreltwiddler/CanIMogIt/issues/129) Improved Auctioneer check to only disable the overlay when CompactUI is enabled.
* [#130](https://gitlab.com/toreltwiddler/CanIMogIt/issues/130) Bind on Pickup items that cannot be learned by your current character will now show the green negative icon everywhere (vendors, looting, etc.).
* [#131](https://gitlab.com/toreltwiddler/CanIMogIt/issues/131) Fixed bug when Blizzard's guild bank frames aren't loaded due to an addon (Bagnon).

*****

7.3.0.04 Release - 2017/10/08

Prevent Auctioneer from loading icons.

* [#127](https://gitlab.com/toreltwiddler/CanIMogIt/issues/127) Prevent the icon overlays from showing up in the Auction House when Auctioneer is enabled (it is not yet supported).

*****

7.3.0.03 Release - 2017/10/08

Bug fixes for overlay.

* [#119](https://gitlab.com/toreltwiddler/CanIMogIt/issues/119) Overlay now uses Blizzard constants in more places, which means addons like Extended Vendor UI will work more often (although they may still have [issues](https://gitlab.com/toreltwiddler/CanIMogIt/issues/53)).
* [#116](https://gitlab.com/toreltwiddler/CanIMogIt/issues/116) & [#117](https://gitlab.com/toreltwiddler/CanIMogIt/issues/117) Auction House overlay now updates when options are changed and is included in the Show Bag Icons option.

*****

7.3.0.02 Release - 2017/09/10

Bug fixes.

* [#95](https://gitlab.com/toreltwiddler/CanIMogIt/issues/95) Tooltips and bags overlay will now properly display Cannot Learn: Soulbound instead of Cannot Learn: Reason if you moused over an item before looting.
* [#98](https://gitlab.com/toreltwiddler/CanIMogIt/issues/98) Encounter Journal overlay will update if you have it open and then loot and learn an item.

*****

7.3.0.01 Release - 2017/08/29

Bump TOC for 7.3.

*****

7.2.5.04 Release - 2017/08/26

ElvUI bags and bank now have the overlay!

![ElvUI bags & bank overlay!](http://i.imgur.com/5ZJMZGb.png "ElvUI bags & bank overlay!")

* [#18](https://gitlab.com/toreltwiddler/CanIMogIt/issues/18) Added some more slash commands.
* [#44](https://gitlab.com/toreltwiddler/CanIMogIt/issues/44) Added support for ElvUI bags and bank.  Also Tradeskills windows now update correctly.
* [#106](https://gitlab.com/toreltwiddler/CanIMogIt/issues/106) Updated options menu checkbox sound to use 7.3 API.
* [#112](https://gitlab.com/toreltwiddler/CanIMogIt/issues/112) Cleaned up Locales in TOC.

*****

7.2.5.03 Release - 2017/08/20

Prevents errors with addons that overwrite the default Auction House.

*****

7.2.5.02 Release - 2017/08/20

Auction House now has the overlay!

![Auction House overlay!](http://i.imgur.com/5jrKJxs.png "Auction House overlay!")

* [#24](https://gitlab.com/toreltwiddler/CanIMogIt/issues/24) Added the overlay to the default Auction House (code from crappyusername).
* [#97](https://gitlab.com/toreltwiddler/CanIMogIt/issues/97) Separated the overlay code into different files and their own subfolder.

*****

7.2.5.01 Release - 2017/07/16

Release of database change.  You cannot downgrade from this version to older versions!  If you do you will have to delete your CanIMogIt.lua save variables file!

*****

7.2.5.01 Beta - 2017/07/09

Changed how the database stores items so that items of different types that share appearances are not stored together.

*****

7.2.0.04 Release - 2017/06/10

Fixed log-in and loading screen lag. ([#58](https://gitlab.com/toreltwiddler/CanIMogIt/issues/58) & [#89](https://gitlab.com/toreltwiddler/CanIMogIt/issues/89))

*****

7.2.0.03 Release - 2017/05/07

ArkInventory now supported!

![ArkInventory support!](http://i.imgur.com/l4PNjqA.png "ArkInventory support!")

* [#40](https://gitlab.com/toreltwiddler/CanIMogIt/issues/40) Added ArkInventory support (with code from @Urtgard).

*****

7.2.0.02 Release - 2017/04/16

New feature: Progress numbers added to the Appearance Sets list!

![Appearance Sets Counter](http://i.imgur.com/FDdXyF2.png "Appearance Sets Counter")

* [#79](https://gitlab.com/toreltwiddler/CanIMogIt/issues/79) Bugfix with Timewalking items and source type.
* [#71](https://gitlab.com/toreltwiddler/CanIMogIt/issues/71) Added small ratio for variants in Sets window.
* Updated TOC to 7.2.

*****

7.2.0.01 Release

Added tooltips for new Transmog Sets.

![Sets Tooltips](http://i.imgur.com/1cD68tw.png "Sets Tooltips")

18 Mar, 2017

* [#70](https://gitlab.com/toreltwiddler/CanIMogIt/issues/70) & [#72](https://gitlab.com/toreltwiddler/CanIMogIt/issues/72) Added set information to the tooltip, along with an option to enable/disable.
* [#55](https://gitlab.com/toreltwiddler/CanIMogIt/issues/55) Updated C_TransmogCollection.ClearSearch to use 7.2 api.

*****

7.1.5.05 Release

Bug fixes.

18 Mar, 2017

* [#67](https://gitlab.com/toreltwiddler/CanIMogIt/issues/67) Fixed bug with too low level and cannot learn transmog.
* [#67](https://gitlab.com/toreltwiddler/CanIMogIt/issues/67) Adjusted logic to for being too low level to make more sense.

05 Mar, 2017

* [#59](https://gitlab.com/toreltwiddler/CanIMogIt/issues/59) Optimizations for checking/updating the database.
* [#31](https://gitlab.com/toreltwiddler/CanIMogIt/issues/31) Fixed icon overlay not updating when bags are opened individually.
* [#48](https://gitlab.com/toreltwiddler/CanIMogIt/issues/48) Fixed bug with weapons returning as equippable incorrectly.
