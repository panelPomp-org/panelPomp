
## Governance of **panelPomp**

**panelPomp** is organized as a collaborative project, directed by its core development team. Core developers are as follows:

| Name          | Start date | End date | Comments        |
| ------------- | ---------- | -------- | --------------- |
| Carles Breto  |  5/22/16   |          | founding member |
| Aaron King    |  5/22/16   |          | founding member |
| Ed Ionides    |  5/22/16   |          | founding member | 
| Jesse Wheeler |  5/30/23   |          |                 |

The maintainer was Carles Breto until 8/26/24, at which point Jesse Wheeler took that position.

We have a few rules, sufficient for a small and friendly project.

## Rules

1. Decisions are made by a majority vote of the core developers. A simple majority of votes in support of a decision (greater than half the number of members of core developers) is required for a decision to be passed.

2. The core development team votes to select a maintainer who is responsible for keeping an up-to-date version of panelPomp on CRAN.

3. All core developers can edit the source code without requiring approval from other core developers.  All core developers can incorporate edits proposed by other contributors. No developer should change the edit history, and therefore any change can be reversed if the core development team decides to do so.

4. New core developers are selected by a vote of the existing core developers.

5. Anyone who writes code included in panelPomp is a contributor. A core developer can also add someone to a list of contributors if they have contributed to the project in some other way such as writing open-source applications using panelPomp.

## Version Numbering 

The panelPomp package has undergone several style changes in the version numbering system used.
Early versions of the package used only a two digit numbering system (`X.Y`).
Later this was updated to a three digit system with update `0.5.4`, and a four digit system with version `0.10.2.0`.
After that point, the package underwent several changes between the three and four digit numbering systems.
Starting September 5, 2024, the package will now revert to the four digit numbering system, and all updates to the package are expected to follow this style. 
The goals of this change include: 

- Make the panelPomp version numbering system consistent with that of the pomp package.
- Improved consistency with updates to version numbering.
- Clarify how each update will affect users and developers of the package. 

The four number system works as follows: 

```
W.X.Y.Z
```


Every update of the package will increment one of the version numbers by one.
If any of the version numbers increments, then all subsequent version numbers will reset to zero.
Changes in `W` reflect major and breaking changes. 
The digits `W.X` will match the latest CRAN release. 
Changes in `Y` represent user-facing changes, and changes in `Z` reflect internal changes only. 

