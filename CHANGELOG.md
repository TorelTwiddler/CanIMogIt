8.2.5v1.20 Release - 2019/11/12

* [#214](https://gitlab.com/toreltwiddler/CanIMogIt/issues/214) Fixed options showing up outside of settings window.

*****

8.2.5v1.19 Release - 2019/11/12

* [#213](https://gitlab.com/toreltwiddler/CanIMogIt/issues/213) Changed Icon Location dropdown to a radio button grid to avoid taint.

*****

8.2.5v1.18 Release - 2019/10/23

* [#212](https://gitlab.com/toreltwiddler/CanIMogIt/issues/212) Added C_Timer.After for ArkInventory so CIMI's options are loaded.

*****

8.2.5v1.17 Release - 2019/10/22

Icon location can now be changed! /cimi to open the options menu!

![Icons move](https://i.imgur.com/eTUv7pI.gif)

* [#11](https://gitlab.com/toreltwiddler/CanIMogIt/issues/11) Added option to move the icon location everywhere except for on Quests and in the Adventure Journal.
* [#210](https://gitlab.com/toreltwiddler/CanIMogIt/issues/210) Fixed Bagnon not working in some cases by adding to Optional Dependencies.

*****

8.2.5v1.16 Release - 2019/10/05

Fixes for errors and TOC update.

* [#207](https://gitlab.com/toreltwiddler/CanIMogIt/issues/207) No longer updates appearances during loading screens.
* [#208](https://gitlab.com/toreltwiddler/CanIMogIt/issues/208) Makes sure item link is valid before adding to DB.
* Updated TOC.

*****

8.2.0v1.15 Release - 2019/06/25

* [#204](https://gitlab.com/toreltwiddler/CanIMogIt/issues/204) Change Blizzard constant for mail attachments in received mail window.
* [#205](https://gitlab.com/toreltwiddler/CanIMogIt/issues/205) ArkInventory overlay plugin update.
* Updated TOC.

*****

8.1.5v1.14 Release - 2019/03/14

* [#202](https://gitlab.com/toreltwiddler/CanIMogIt/issues/202) Fixed error due to removal of WorldMapTooltip.
* Updated TOC.

*****

8.0.0v1.13 Release - 2018/10/17

Added Bagnon support (thanks to LudiusMaximus).

* [#42](https://gitlab.com/toreltwiddler/CanIMogIt/issues/42) Added Bagnon support.
* [#163](https://gitlab.com/toreltwiddler/CanIMogIt/issues/163) Fixed memory issue with Battle Pets.

*****

8.0.0v1.12 Release - 2018/10/11

Fixed issue with icons being left behind.

* [#187](https://gitlab.com/toreltwiddler/CanIMogIt/issues/187) Changed containers to hook UpgradeIcon event.

*****

8.0.0v1.11 Release - 2018/08/05

Added the overlay to the quests frame!

![Quest Overlay](https://i.imgur.com/HAvpSIa.jpg)

* [#25](https://gitlab.com/toreltwiddler/CanIMogIt/issues/25) Added the overlay to the quests frames.
* [#192](https://gitlab.com/toreltwiddler/CanIMogIt/issues/192) Prevent error when sourceID is nil for learning appearances.
* [#193](https://gitlab.com/toreltwiddler/CanIMogIt/issues/193) Added database debug print command, /cimi dbprint.
* [#194](https://gitlab.com/toreltwiddler/CanIMogIt/issues/194) Add value of tooltip text result to debug tooltip.
* Workaround for GET_ITEM_INFO_RECEIVED bug from 8.0 added by Resike.

*****

8.0.0v1.10 Release - 2018/07/29

Fixed ArkInventory.

* [#86](https://gitlab.com/toreltwiddler/CanIMogIt/issues/86) & [#190](https://gitlab.com/toreltwiddler/CanIMogIt/issues/190)  Fixed ArkInventory overlay and ArkInventory offline character mode.
* [#187](https://gitlab.com/toreltwiddler/CanIMogIt/issues/187) Fixed overlay not always updating after certain actions.
* [#191](https://gitlab.com/toreltwiddler/CanIMogIt/issues/191) Added 3 BfA pre-patch world quest items to exception list (monk shoulders, monk gloves, hunter shoulders).

*****

8.0.0v1.9 Release - 2018/07/17

Patch 8.0 and LiteBag support.

![LiteBag overlay!](https://i.imgur.com/H1sDNSl.png)

* [#38](https://gitlab.com/toreltwiddler/CanIMogIt/issues/38) LiteBag support added by LiteBag author Xodiv.
* Updated TOC.

*****

7.3.5v1.8 Release - 2018/07/09

Items with Class Restrictions are now properly considered for if you know the appearance or not based on the class you are on.

Bug fixes & Improvements

* Added "/cimi count" which reports the total number of known appearances across all characters.
* [#185](https://gitlab.com/toreltwiddler/CanIMogIt/issues/185) Fixed issue with class restrictions not being taken into account.
* [#168](https://gitlab.com/toreltwiddler/CanIMogIt/issues/168) & [#176](https://gitlab.com/toreltwiddler/CanIMogIt/issues/176) Fixes for database storage of Class Restriction information.
* [#182](https://gitlab.com/toreltwiddler/CanIMogIt/issues/182) Fixes PairByKeys error when jumping from a very old version of the addon to a new version.
* [#172](https://gitlab.com/toreltwiddler/CanIMogIt/issues/172) Fixes the tooltip not showing up after multiple chat link clicks.

*****

7.3.5v1.7.2 Release - 2018/05/27

* [#169](https://gitlab.com/toreltwiddler/CanIMogIt/issues/169) Avoid lag when looting by only recalculating the looted item, not all items.

*****

7.3.5v1.7.1 Release - 2018/03/30

* [#174](https://gitlab.com/toreltwiddler/CanIMogIt/issues/174) & [#175](https://gitlab.com/toreltwiddler/CanIMogIt/issues/175) Hopefully prevents memory leak by removing DressUpModel redraw.

*****

7.3.5v1.7 Release - 2018/03/25

Bug fixes

* [#151](https://gitlab.com/toreltwiddler/CanIMogIt/issues/151) Hopefully fixes the DressUpModel giving bad source IDs.
* [#167](https://gitlab.com/toreltwiddler/CanIMogIt/issues/167) Add trial/boost versions of invisible Salvage Yard items to exception list.

*****

7.3.2v1.6 Release - 2018/01/15

Added Black Market Auction House overlay!

![Black Market Auction House overlay!](https://i.imgur.com/j33ZMKb.png)

* [#152](https://gitlab.com/toreltwiddler/CanIMogIt/issues/152) Added overlay to Black Market Auction House.
* [#153](https://gitlab.com/toreltwiddler/CanIMogIt/issues/153) Hopefully prevented errors when the cache is reset mid-calculations.

*****

7.3.2v1.5 Release - 2017/12/27

Bug fix: Fix nil cache errors and compounding lag.

* [#144](https://gitlab.com/toreltwiddler/CanIMogIt/issues/144) & [#145](https://gitlab.com/toreltwiddler/CanIMogIt/issues/145) Changed order of cache.lua and code.lua in TOC to prevent missing cache issue.
* [#146](https://gitlab.com/toreltwiddler/CanIMogIt/issues/146) Fix compounding lag caused from getting source ID from DressUpModel frame.
* [#150](https://gitlab.com/toreltwiddler/CanIMogIt/issues/150) Changed the debug tooltip to not reset the cache.

*****

7.3.2v1.4 Release - 2017/12/16

Bug fix: Overlay and tooltip should now always update after learning an item.  If it does not please let us know!

* [#133](https://gitlab.com/toreltwiddler/CanIMogIt/issues/133) Changed how caching is stored, from itemLink to sourceID to hopefully properly remove items from the cache.

*****

7.3.2v1.3 Release - 2017/11/29

Bug fix: Set appearance list now properly updates.

* [142](https://gitlab.com/toreltwiddler/CanIMogIt/issues/142) Fixed set list ratio text not updating when learning appearance.

*****

7.3.2v1.2 Release - 2017/11/27

Bug fixes

* [#14](https://gitlab.com/toreltwiddler/CanIMogIt/issues/14) Duplicate tooltips should no longer happen (ElvUI, TipTac, Guild Rewards window, etc.)
* [#105](https://gitlab.com/toreltwiddler/CanIMogIt/issues/105) Deadeye Monocle marked as Cannot be learned.
* [#133](https://gitlab.com/toreltwiddler/CanIMogIt/issues/133) Slight delay added to tooltip/icon update to try to prevent it missing the event and not updating at all.
* [#134](https://gitlab.com/toreltwiddler/CanIMogIt/issues/134) Patterns that craft an item now properly show tooltips.  (Only the pattern shows the tooltip, not the item listed on it.)
* [#138](https://gitlab.com/toreltwiddler/CanIMogIt/issues/138) Set count now updates when learning/unlearning an item.
* [#139](https://gitlab.com/toreltwiddler/CanIMogIt/issues/139) Hopefully fixed the bad sourceID issue which was causing Cannot Learn messages on unexpected items.

Improvments

* [#132](https://gitlab.com/toreltwiddler/CanIMogIt/issues/132) Tooltip and overlay added to Mythic Keystones.
* Added tooltips to crafting reagents in crafting windows.
* Rework of tooltip generation to be more consistent across the game.

*****

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
