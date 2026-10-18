local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StructureConfig = {}

local sharedAssets = ReplicatedStorage.SharedAssets
local castleAssets = sharedAssets.Castle
local castleProgressions = castleAssets.Progression
local firstFloorProgressions = castleProgressions["1stFloor"];
local secondFloorProgressions = castleProgressions["2ndFloor"];

StructureConfig.FLOOR_NAMES = {
    Floor1 = "Floor1";
    Floor2 = "Floor2";
    Floor3 = "Floor3";
    Floor4 = "Floor4";
}

StructureConfig.STRUCTURE_NAMES = {
    -- 1ST FLOOR
    Pathway1 = "Pathway1";
    Bushes1 = "Bushes1";
    Bushes2 = "Bushes2";
    Staircase1 = "Staircase1";
    Lamps1 = "Lamps1";
    Staircase2 = "Staircase2";
    Fountain1 = "Fountain1";
    Lamps2 = "Lamps2";
    Walls1 = "Walls1";
    Banner1 = "Banner1";
    Bush1 = "Bush1";
    CastleTower1 = "CastleTower1";
    Banner2 = "Banner2";
    Bush2 = "Bush2";
    CastleTower2 = "CastleTower2";
    Floor1 = "Floor1";
    Entrance1 = "Entrance1";
    Walls2 = "Walls2";
    Windows1 = "Windows1";
    Windows2 = "Windows2";
    Columns1 = "Columns1";
    Lamps3 = "Lamps3";
    Columns2 = "Columns2";
    Lamps4 = "Lamps4";
    Carpet1 = "Carpet1";
    Walls3 = "Walls3";
    Columns3 = "Columns3";
    Doorways1 = "Doorways1";
    Walls4 = "Walls4";
    Columns4 = "Columns4";
    Windows3 = "Windows3";
    Walls5 = "Walls5";
    Columns5 = "Columns5";
    Doorways2 = "Doorways2";
    Walls6 = "Walls6";
    Columns6 = "Columns6";
    Windows4 = "Windows4";
    Wall1 = "Wall1";
    Wall2 = "Wall2";
    Staircase3 = "Staircase3";
    Carpet2 = "Carpet2";
    Display1 = "Display1";
    Wall3 = "Wall3";
    Wall4 = "Wall4";
    Ceiling1 = "Ceiling1";
    Plants1 = "Plants1";
    Candelabras1 = "Candelabras1";
    Chandeliers1 = "Chandeliers1";
    Knights1 = "Knights1";
    Carpet3 = "Carpet3";
    Decorations1 = "Decorations1";
    Piano1 = "Piano1";
    Decorations2 = "Decorations2";
    Banner3AndPainting1 = "Banner3AndPainting1";
    Knights2 = "Knights2";
    Candelabras2 = "Candelabras2";
    Chandeliers2 = "Chandeliers2";
    Decorations3 = "Decorations3";
    ChessTable1 = "ChessTable1";
    Decorations4 = "Decorations4";
    Painting2 = "Painting2";
    AngelStatue1 = "AngelStatue1";
    Banner4 = "Banner4";

    -- 2ND FLOOR
    Walls7 = "Walls7";
    Columns7 = "Columns7";
    Doorway1 = "Doorway1";
    Fences1 = "Fences1";
    FlowerPots1 = "FlowerPots1";
    Chandeliers3 = "Chandeliers3";
    Carpet4 = "Carpet4";
    Wall5 = "Wall5";
    Walls8 = "Walls8";
    Columns8 = "Columns8";
    Windows5 = "Windows5";
    SwordAndShield1 = "SwordAndShield1";
    Knight1 = "Knight1";
    Decorations5 = "Decorations5";
    KnightStatue1 = "KnightStatue1";
    Decorations6 = "Decorations6";
    Candelabras3 = "Candelabras3";
    Banner5 = "Banner5";
    Banner6 = "Banner6";
    Banner7 = "Banner7";
    Walls9 = "Walls9";
    Columns9 = "Columns9";
    Doorway2 = "Doorway2";
    Fences2 = "Fences2";
    FlowerPots2 = "FlowerPots2";
    Chandeliers4 = "Chandeliers4";
    Carpet5 = "Carpet5";
    Wall6 = "Wall6";
    Walls10 = "Walls10";
    Columns10 = "Columns10";
    Windows6 = "Windows6";
    SwordAndShield2 = "SwordAndShield2";
    Knight2 = "Knight2";
    Candelabras4 = "Candelabras4";
    Banner8 = "Banner8";
    Banner9 = "Banner9";
    Banner10 = "Banner10";
    Decorations7 = "Decorations7";
    KnightStatue2 = "KnightStatue2";
    Decorations8 = "Decorations8";
    CastleTower3 = "CastleTower3";
    Doorway3 = "Doorway3";
    Floor2 = "Floor2";
    Fence1 = "Fence1";
    Stairs1 = "Stairs1";
    Stairs2 = "Stairs2";
    Wall7 = "Wall7";
    Stairs3 = "Stairs3";
    Floor3 = "Floor3";
    Stairs4 = "Stairs4";
    Fence2 = "Fence2";
    Doorway4 = "Doorway4";
    CastleTower4 = "CastleTower4";
}

StructureConfig.STRUCTURE_NAME_TO_ASSET = {
    -- 1ST FLOOR
    [StructureConfig.STRUCTURE_NAMES.Pathway1] = firstFloorProgressions["1. Pathway (10)"];
    [StructureConfig.STRUCTURE_NAMES.Bushes1] = firstFloorProgressions["2. Bushes (20)"];
    [StructureConfig.STRUCTURE_NAMES.Bushes2] = firstFloorProgressions["3. Bushes (20)"];
    [StructureConfig.STRUCTURE_NAMES.Staircase1] = firstFloorProgressions["4. Staircase (50)"];
    [StructureConfig.STRUCTURE_NAMES.Lamps1] = firstFloorProgressions["5. Lamps (40)"];
    [StructureConfig.STRUCTURE_NAMES.Staircase2] = firstFloorProgressions["6. Staircase (50)"];
    [StructureConfig.STRUCTURE_NAMES.Fountain1] = firstFloorProgressions["7. Fountain (70)"];
    [StructureConfig.STRUCTURE_NAMES.Lamps2] = firstFloorProgressions["8. Lamps (40)"];
    [StructureConfig.STRUCTURE_NAMES.Walls1] = firstFloorProgressions["9. Walls (200)"];
    [StructureConfig.STRUCTURE_NAMES.Banner1] = firstFloorProgressions["10. Banner (200)"];
    [StructureConfig.STRUCTURE_NAMES.Bush1] = firstFloorProgressions["11. Bush (100)"];
    [StructureConfig.STRUCTURE_NAMES.CastleTower1] = firstFloorProgressions["12. Castle Tower (500)"];
    [StructureConfig.STRUCTURE_NAMES.Banner2] = firstFloorProgressions["13. Banner (200)"];
    [StructureConfig.STRUCTURE_NAMES.Bush2] = firstFloorProgressions["14. Bush (100)"];
    [StructureConfig.STRUCTURE_NAMES.CastleTower2] = firstFloorProgressions["15. Castle Tower (500)"];
    [StructureConfig.STRUCTURE_NAMES.Floor1] = firstFloorProgressions["16. Floor (300)"];
    [StructureConfig.STRUCTURE_NAMES.Entrance1] = firstFloorProgressions["17. Entrance (100)"];
    [StructureConfig.STRUCTURE_NAMES.Walls2] = firstFloorProgressions["18. Walls (250)"];
    [StructureConfig.STRUCTURE_NAMES.Windows1] = firstFloorProgressions["19. Windows (250)"];
    [StructureConfig.STRUCTURE_NAMES.Windows2] = firstFloorProgressions["20. Windows (250)"];
    [StructureConfig.STRUCTURE_NAMES.Columns1] = firstFloorProgressions["21. Columns (100)"];
    [StructureConfig.STRUCTURE_NAMES.Lamps3] = firstFloorProgressions["22. Lamps (50)"];
    [StructureConfig.STRUCTURE_NAMES.Columns2] = firstFloorProgressions["23. Columns (100)"];
    [StructureConfig.STRUCTURE_NAMES.Lamps4] = firstFloorProgressions["24. Lamps (50)"];
    [StructureConfig.STRUCTURE_NAMES.Carpet1] = firstFloorProgressions["25. Carpet (100)"];
    [StructureConfig.STRUCTURE_NAMES.Walls3] = firstFloorProgressions["26. Walls (250)"];
    [StructureConfig.STRUCTURE_NAMES.Columns3] = firstFloorProgressions["27. Columns (250)"];
    [StructureConfig.STRUCTURE_NAMES.Doorways1] = firstFloorProgressions["28. Doorways (250)"];
    [StructureConfig.STRUCTURE_NAMES.Walls4] = firstFloorProgressions["29. Walls (250)"];
    [StructureConfig.STRUCTURE_NAMES.Columns4] = firstFloorProgressions["30. Columns (250)"];
    [StructureConfig.STRUCTURE_NAMES.Windows3] = firstFloorProgressions["31. Windows (250)"];
    [StructureConfig.STRUCTURE_NAMES.Walls5] = firstFloorProgressions["32. Walls (250)"];
    [StructureConfig.STRUCTURE_NAMES.Columns5] = firstFloorProgressions["33. Columns (250)"];
    [StructureConfig.STRUCTURE_NAMES.Doorways2] = firstFloorProgressions["34. Doorways (250)"];
    [StructureConfig.STRUCTURE_NAMES.Walls6] = firstFloorProgressions["35. Walls (250)"];
    [StructureConfig.STRUCTURE_NAMES.Columns6] = firstFloorProgressions["36. Columns (250)"];
    [StructureConfig.STRUCTURE_NAMES.Windows4] = firstFloorProgressions["37. Windows (250)"];
    [StructureConfig.STRUCTURE_NAMES.Wall1] = firstFloorProgressions["38. Wall (250)"];
    [StructureConfig.STRUCTURE_NAMES.Wall2] = firstFloorProgressions["39. Wall (250)"];
    [StructureConfig.STRUCTURE_NAMES.Staircase3] = firstFloorProgressions["40. Staircase (400)"];
    [StructureConfig.STRUCTURE_NAMES.Carpet2] = firstFloorProgressions["41. Carpet (250)"];
    [StructureConfig.STRUCTURE_NAMES.Display1] = firstFloorProgressions["42. Display (500)"];
    [StructureConfig.STRUCTURE_NAMES.Wall3] = firstFloorProgressions["43. Wall (250)"];
    [StructureConfig.STRUCTURE_NAMES.Wall4] = firstFloorProgressions["44. Wall (250)"];
    [StructureConfig.STRUCTURE_NAMES.Ceiling1] = firstFloorProgressions["45. Ceiling (400)"];
    [StructureConfig.STRUCTURE_NAMES.Plants1] = firstFloorProgressions["46. Plants (200)"];
    [StructureConfig.STRUCTURE_NAMES.Candelabras1] = firstFloorProgressions["47. Candelabras (250)"];
    [StructureConfig.STRUCTURE_NAMES.Chandeliers1] = firstFloorProgressions["48. Chandeliers (250)"];
    [StructureConfig.STRUCTURE_NAMES.Knights1] = firstFloorProgressions["49. Knights (250)"];
    [StructureConfig.STRUCTURE_NAMES.Carpet3] = firstFloorProgressions["50. Carpet (100)"];
    [StructureConfig.STRUCTURE_NAMES.Decorations1] = firstFloorProgressions["51. Decorations (400)"];
    [StructureConfig.STRUCTURE_NAMES.Piano1] = firstFloorProgressions["52. Piano (400)"];
    [StructureConfig.STRUCTURE_NAMES.Decorations2] = firstFloorProgressions["53. Decorations (400)"];
    [StructureConfig.STRUCTURE_NAMES.Banner3AndPainting1] = firstFloorProgressions["54. Banner + Painting (500)"];
    [StructureConfig.STRUCTURE_NAMES.Knights2] = firstFloorProgressions["55. Knights (250)"];
    [StructureConfig.STRUCTURE_NAMES.Candelabras2] = firstFloorProgressions["56. Candelabras (250)"];
    [StructureConfig.STRUCTURE_NAMES.Chandeliers2] = firstFloorProgressions["57. Chandeliers (250)"];
    [StructureConfig.STRUCTURE_NAMES.Decorations3] = firstFloorProgressions["58. Decorations (400)"];
    [StructureConfig.STRUCTURE_NAMES.ChessTable1] = firstFloorProgressions["59. Chess Table (400)"];
    [StructureConfig.STRUCTURE_NAMES.Decorations4] = firstFloorProgressions["60. Decorations (400)"];
    [StructureConfig.STRUCTURE_NAMES.Painting2] = firstFloorProgressions["61. Painting (250)"];
    [StructureConfig.STRUCTURE_NAMES.AngelStatue1] = firstFloorProgressions["62. Angel Statue (1k)"];
    [StructureConfig.STRUCTURE_NAMES.Banner4] = firstFloorProgressions["63. Banner (250)"];

    -- 2ND FLOOR
    [StructureConfig.STRUCTURE_NAMES.Walls7] = secondFloorProgressions["64. Walls (1.5k)"];
    [StructureConfig.STRUCTURE_NAMES.Columns7] = secondFloorProgressions["65. Columns (2k)"];
    [StructureConfig.STRUCTURE_NAMES.Doorway1] = secondFloorProgressions["66. Doorway (2.2k)"];
    [StructureConfig.STRUCTURE_NAMES.Fences1] = secondFloorProgressions["67. Fences (2.5k)"];
    [StructureConfig.STRUCTURE_NAMES.FlowerPots1] = secondFloorProgressions["68. Flower Pots (3k)"];
    [StructureConfig.STRUCTURE_NAMES.Chandeliers3] = secondFloorProgressions["69. Chandeliers (3k)"];
    [StructureConfig.STRUCTURE_NAMES.Carpet4] = secondFloorProgressions["70. Carpet (3.5k)"];
    [StructureConfig.STRUCTURE_NAMES.Wall5] = secondFloorProgressions["71. Wall (4k)"];
    [StructureConfig.STRUCTURE_NAMES.Walls8] = secondFloorProgressions["72. Walls (3k)"];
    [StructureConfig.STRUCTURE_NAMES.Columns8] = secondFloorProgressions["73. Columns (3.5k)"];
    [StructureConfig.STRUCTURE_NAMES.Windows5] = secondFloorProgressions["74. Windows (5k)"];
    [StructureConfig.STRUCTURE_NAMES.SwordAndShield1] = secondFloorProgressions["75. Sword & Shield (6k)"];
    [StructureConfig.STRUCTURE_NAMES.Knight1] = secondFloorProgressions["76. Knight (6k)"];
    [StructureConfig.STRUCTURE_NAMES.Decorations5] = secondFloorProgressions["77. Decorations (7k)"];
    [StructureConfig.STRUCTURE_NAMES.KnightStatue1] = secondFloorProgressions["78. Knight Statue (8k)"];
    [StructureConfig.STRUCTURE_NAMES.Decorations6] = secondFloorProgressions["79. Decorations (7k)"];
    [StructureConfig.STRUCTURE_NAMES.Candelabras3] = secondFloorProgressions["80. Candelabras (3k)"];
    [StructureConfig.STRUCTURE_NAMES.Banner5] = secondFloorProgressions["81. Banner (1k)"];
    [StructureConfig.STRUCTURE_NAMES.Banner6] = secondFloorProgressions["82. Banner (1k)"];
    [StructureConfig.STRUCTURE_NAMES.Banner7] = secondFloorProgressions["83. Banner (1k)"];
    [StructureConfig.STRUCTURE_NAMES.Walls9] = secondFloorProgressions["84. Walls (1.5k)"];
    [StructureConfig.STRUCTURE_NAMES.Columns9] = secondFloorProgressions["85. Columns (1k)"];
    [StructureConfig.STRUCTURE_NAMES.Doorway2] = secondFloorProgressions["86. Doorway (2k)"];
    [StructureConfig.STRUCTURE_NAMES.Fences2] = secondFloorProgressions["87. Fences (2k)"];
    [StructureConfig.STRUCTURE_NAMES.FlowerPots2] = secondFloorProgressions["88. Flower Pots (2k)"];
    [StructureConfig.STRUCTURE_NAMES.Chandeliers4] = secondFloorProgressions["89. Chandeliers (3k)"];
    [StructureConfig.STRUCTURE_NAMES.Carpet5] = secondFloorProgressions["90. Carpet (2k)"];
    [StructureConfig.STRUCTURE_NAMES.Wall6] = secondFloorProgressions["91. Wall (4k)"];
    [StructureConfig.STRUCTURE_NAMES.Walls10] = secondFloorProgressions["92. Walls (3k)"];
    [StructureConfig.STRUCTURE_NAMES.Columns10] = secondFloorProgressions["93. Columns (4k)"];
    [StructureConfig.STRUCTURE_NAMES.Windows6] = secondFloorProgressions["94. Windows (5k)"];
    [StructureConfig.STRUCTURE_NAMES.SwordAndShield2] = secondFloorProgressions["95. Sword & Shield (6k)"];
    [StructureConfig.STRUCTURE_NAMES.Knight2] = secondFloorProgressions["96. Knight (6k)"];
    [StructureConfig.STRUCTURE_NAMES.Candelabras4] = secondFloorProgressions["97. Candelabras (3k)"];
    [StructureConfig.STRUCTURE_NAMES.Banner8] = secondFloorProgressions["98. Banner (1k)"];
    [StructureConfig.STRUCTURE_NAMES.Banner9] = secondFloorProgressions["99. Banner (1k)"];
    [StructureConfig.STRUCTURE_NAMES.Banner10] = secondFloorProgressions["100. Banner (1k)"];
    [StructureConfig.STRUCTURE_NAMES.Decorations7] = secondFloorProgressions["101. Decorations (7k)"];
    [StructureConfig.STRUCTURE_NAMES.KnightStatue2] = secondFloorProgressions["102. Knight Statue (8k)"];
    [StructureConfig.STRUCTURE_NAMES.Decorations8] = secondFloorProgressions["103. Decorations (7k)"];
    [StructureConfig.STRUCTURE_NAMES.CastleTower3] = secondFloorProgressions["104. Castle Tower (5k)"];
    [StructureConfig.STRUCTURE_NAMES.Doorway3] = secondFloorProgressions["105. Doorway (2k)"];
    [StructureConfig.STRUCTURE_NAMES.Floor2] = secondFloorProgressions["106. Floor (2k)"];
    [StructureConfig.STRUCTURE_NAMES.Fence1] = secondFloorProgressions["107. Fence (2k)"];
    [StructureConfig.STRUCTURE_NAMES.Stairs1] = secondFloorProgressions["108. Stairs (2k)"];
    [StructureConfig.STRUCTURE_NAMES.Stairs2] = secondFloorProgressions["109. Stairs (2k)"];
    [StructureConfig.STRUCTURE_NAMES.Wall7] = secondFloorProgressions["110. Wall (2k)"];
    [StructureConfig.STRUCTURE_NAMES.Stairs3] = secondFloorProgressions["111. Stairs (2k)"];
    [StructureConfig.STRUCTURE_NAMES.Floor3] = secondFloorProgressions["112. Floor (2k)"];
    [StructureConfig.STRUCTURE_NAMES.Stairs4] = secondFloorProgressions["113. Stairs (2k)"];
    [StructureConfig.STRUCTURE_NAMES.Fence2] = secondFloorProgressions["114. Fence (2k)"];
    [StructureConfig.STRUCTURE_NAMES.Doorway4] = secondFloorProgressions["115. Doorway (2k)"];
    [StructureConfig.STRUCTURE_NAMES.CastleTower4] = secondFloorProgressions["116. Castle Tower (5k)"];
}

StructureConfig.FLOOR_END_STRUCTURES = {
    [StructureConfig.FLOOR_NAMES.Floor1] = {
        ["start"] = StructureConfig.STRUCTURE_NAMES.Pathway1;
        ["end"] = StructureConfig.STRUCTURE_NAMES.Pathway1; -- Banner4
    };
    [StructureConfig.FLOOR_NAMES.Floor2] = {
        ["start"] = StructureConfig.STRUCTURE_NAMES.Walls7;
        ["end"] = StructureConfig.STRUCTURE_NAMES.CastleTower4;
    };

    --TODO: ACTUALLY FILL THESE UP
    [StructureConfig.FLOOR_NAMES.Floor3] = {
        ["start"] = StructureConfig.STRUCTURE_NAMES.Walls7;
        ["end"] = StructureConfig.STRUCTURE_NAMES.CastleTower4;
    };
    [StructureConfig.FLOOR_NAMES.Floor4] = {
        ["start"] = StructureConfig.STRUCTURE_NAMES.Walls7;
        ["end"] = StructureConfig.STRUCTURE_NAMES.CastleTower4;
    };
}

export type StructureConfig = {
    title: string;
    cost: {
        gold: number;
    };
    purchaseable: {string};
}

StructureConfig.STRUCTURE_CONFIG_DATA = {
    -- 1ST FLOOR
    [StructureConfig.STRUCTURE_NAMES.Pathway1] = { title = "Pathway", cost = { gold = 30 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Bushes1 } };
    [StructureConfig.STRUCTURE_NAMES.Bushes1] = { title = "Bushes", cost = { gold = 65 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Bushes2 }  };
    [StructureConfig.STRUCTURE_NAMES.Bushes2] = { title = "Bushes", cost = { gold = 65 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Staircase1 } };
    [StructureConfig.STRUCTURE_NAMES.Staircase1] = { title = "Staircase", cost = { gold = 100 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Lamps1 } };
    [StructureConfig.STRUCTURE_NAMES.Lamps1] = { title = "Lamps", cost = { gold = 40 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Staircase2 } };
    [StructureConfig.STRUCTURE_NAMES.Staircase2] = { title = "Staircase", cost = { gold = 100 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Fountain1 } };
    [StructureConfig.STRUCTURE_NAMES.Fountain1] = { title = "Fountain", cost = { gold = 70 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Lamps2 } };
    [StructureConfig.STRUCTURE_NAMES.Lamps2] = { title = "Lamps", cost = { gold = 40 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Walls1 } };
    [StructureConfig.STRUCTURE_NAMES.Walls1] = { title = "Walls", cost = { gold = 200 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Banner1 } };
    [StructureConfig.STRUCTURE_NAMES.Banner1] = { title = "Banner", cost = { gold = 70 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Bush1 } };
    [StructureConfig.STRUCTURE_NAMES.Bush1] = { title = "Bush", cost = { gold = 100 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.CastleTower1 } };
    [StructureConfig.STRUCTURE_NAMES.CastleTower1] = { title = "Castle Tower", cost = { gold = 750 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Banner2 } };
    [StructureConfig.STRUCTURE_NAMES.Banner2] = { title = "Banner", cost = { gold = 70 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Bush2 } };
    [StructureConfig.STRUCTURE_NAMES.Bush2] = { title = "Bush", cost = { gold = 100 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.CastleTower2 } };
    [StructureConfig.STRUCTURE_NAMES.CastleTower2] = { title = "Castle Tower", cost = { gold = 750 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Floor1 } };
    [StructureConfig.STRUCTURE_NAMES.Floor1] = { title = "Floor", cost = { gold = 300 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Entrance1 } };
    [StructureConfig.STRUCTURE_NAMES.Entrance1] = { title = "Entrance", cost = { gold = 100 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Walls2 } };
    [StructureConfig.STRUCTURE_NAMES.Walls2] = { title = "Walls", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Windows1 } };
    [StructureConfig.STRUCTURE_NAMES.Windows1] = { title = "Windows", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Windows2 } };
    [StructureConfig.STRUCTURE_NAMES.Windows2] = { title = "Windows", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Columns1 } };
    [StructureConfig.STRUCTURE_NAMES.Columns1] = { title = "Columns", cost = { gold = 200 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Lamps3 } };
    [StructureConfig.STRUCTURE_NAMES.Lamps3] = { title = "Lamps", cost = { gold = 50 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Columns2 } };
    [StructureConfig.STRUCTURE_NAMES.Columns2] = { title = "Columns", cost = { gold = 200 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Lamps4 } };
    [StructureConfig.STRUCTURE_NAMES.Lamps4] = { title = "Lamps", cost = { gold = 50 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Carpet1 } };
    [StructureConfig.STRUCTURE_NAMES.Carpet1] = { title = "Carpet", cost = { gold = 100 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Walls3 } };
    [StructureConfig.STRUCTURE_NAMES.Walls3] = { title = "Walls", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Columns3 } };
    [StructureConfig.STRUCTURE_NAMES.Columns3] = { title = "Columns", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Doorways1 } };
    [StructureConfig.STRUCTURE_NAMES.Doorways1] = { title = "Doorways", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Walls4 } };
    [StructureConfig.STRUCTURE_NAMES.Walls4] = { title = "Walls", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Columns4 } };
    [StructureConfig.STRUCTURE_NAMES.Columns4] = { title = "Columns", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Windows3 } };
    [StructureConfig.STRUCTURE_NAMES.Windows3] = { title = "Windows", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Walls5 } };
    [StructureConfig.STRUCTURE_NAMES.Walls5] = { title = "Walls", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Columns5 } };
    [StructureConfig.STRUCTURE_NAMES.Columns5] = { title = "Columns", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Doorways2 } };
    [StructureConfig.STRUCTURE_NAMES.Doorways2] = { title = "Doorways", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Walls6 } };
    [StructureConfig.STRUCTURE_NAMES.Walls6] = { title = "Walls", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Columns6 } };
    [StructureConfig.STRUCTURE_NAMES.Columns6] = { title = "Columns", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Windows4 } };
    [StructureConfig.STRUCTURE_NAMES.Windows4] = { title = "Windows", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Wall1 } };
    [StructureConfig.STRUCTURE_NAMES.Wall1] = { title = "Wall", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Wall2 } };
    [StructureConfig.STRUCTURE_NAMES.Wall2] = { title = "Wall", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Staircase3 } };
    [StructureConfig.STRUCTURE_NAMES.Staircase3] = { title = "Staircase", cost = { gold = 400 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Carpet2 } };
    [StructureConfig.STRUCTURE_NAMES.Carpet2] = { title = "Carpet", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Display1 } };
    [StructureConfig.STRUCTURE_NAMES.Display1] = { title = "Display", cost = { gold = 500 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Wall3 } };
    [StructureConfig.STRUCTURE_NAMES.Wall3] = { title = "Wall", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Wall4 } };
    [StructureConfig.STRUCTURE_NAMES.Wall4] = { title = "Wall", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Ceiling1 } };
    [StructureConfig.STRUCTURE_NAMES.Ceiling1] = { title = "Ceiling", cost = { gold = 400 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Plants1 } };
    [StructureConfig.STRUCTURE_NAMES.Plants1] = { title = "Plants", cost = { gold = 200 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Candelabras1 } };
    [StructureConfig.STRUCTURE_NAMES.Candelabras1] = { title = "Candelabras", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Chandeliers1 } };
    [StructureConfig.STRUCTURE_NAMES.Chandeliers1] = { title = "Chandeliers", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Knights1 } };
    [StructureConfig.STRUCTURE_NAMES.Knights1] = { title = "Knights", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Carpet3 } };
    [StructureConfig.STRUCTURE_NAMES.Carpet3] = { title = "Carpet", cost = { gold = 100 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Decorations1 } };
    [StructureConfig.STRUCTURE_NAMES.Decorations1] = { title = "Decorations", cost = { gold = 400 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Piano1 } };
    [StructureConfig.STRUCTURE_NAMES.Piano1] = { title = "Piano", cost = { gold = 400 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Decorations2 } };
    [StructureConfig.STRUCTURE_NAMES.Decorations2] = { title = "Decorations", cost = { gold = 400 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Banner3AndPainting1 } };
    [StructureConfig.STRUCTURE_NAMES.Banner3AndPainting1] = { title = "Banner & Painting", cost = { gold = 500 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Knights2 } };
    [StructureConfig.STRUCTURE_NAMES.Knights2] = { title = "Knights", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Candelabras2 } };
    [StructureConfig.STRUCTURE_NAMES.Candelabras2] = { title = "Candelabras", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Chandeliers2 } };
    [StructureConfig.STRUCTURE_NAMES.Chandeliers2] = { title = "Chandeliers", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Decorations3 } };
    [StructureConfig.STRUCTURE_NAMES.Decorations3] = { title = "Decorations", cost = { gold = 400 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.ChessTable1 } };
    [StructureConfig.STRUCTURE_NAMES.ChessTable1] = { title = "Chess Table", cost = { gold = 400 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Decorations4 } };
    [StructureConfig.STRUCTURE_NAMES.Decorations4] = { title = "Decorations", cost = { gold = 400 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Painting2 } };
    [StructureConfig.STRUCTURE_NAMES.Painting2] = { title = "Painting", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.AngelStatue1 } };
    [StructureConfig.STRUCTURE_NAMES.AngelStatue1] = { title = "Angel Statue", cost = { gold = 1000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Banner4 } };
    [StructureConfig.STRUCTURE_NAMES.Banner4] = { title = "Banner", cost = { gold = 250 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Walls7 } };

    -- 2ND FLOOR
    [StructureConfig.STRUCTURE_NAMES.Walls7] = { title = "Walls", cost = { gold = 1500 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Columns7 } };
    [StructureConfig.STRUCTURE_NAMES.Columns7] = { title = "Columns", cost = { gold = 2000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Doorway1 } };
    [StructureConfig.STRUCTURE_NAMES.Doorway1] = { title = "Doorway", cost = { gold = 2200 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Fences1 } };
    [StructureConfig.STRUCTURE_NAMES.Fences1] = { title = "Fences", cost = { gold = 2500 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.FlowerPots1 } };
    [StructureConfig.STRUCTURE_NAMES.FlowerPots1] = { title = "Flower Pots", cost = { gold = 3000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Chandeliers3 } };
    [StructureConfig.STRUCTURE_NAMES.Chandeliers3] = { title = "Chandeliers", cost = { gold = 3000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Carpet4 } };
    [StructureConfig.STRUCTURE_NAMES.Carpet4] = { title = "Carpet", cost = { gold = 3500 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Wall5 } };
    [StructureConfig.STRUCTURE_NAMES.Wall5] = { title = "Wall", cost = { gold = 4000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Walls8 } };
    [StructureConfig.STRUCTURE_NAMES.Walls8] = { title = "Walls", cost = { gold = 3000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Columns8 } };
    [StructureConfig.STRUCTURE_NAMES.Columns8] = { title = "Columns", cost = { gold = 3500 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Windows5 } };
    [StructureConfig.STRUCTURE_NAMES.Windows5] = { title = "Windows", cost = { gold = 5000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.SwordAndShield1 } };
    [StructureConfig.STRUCTURE_NAMES.SwordAndShield1] = { title = "Sword & Shield", cost = { gold = 6000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Knight1 } };
    [StructureConfig.STRUCTURE_NAMES.Knight1] = { title = "Knight", cost = { gold = 6000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Decorations5 } };
    [StructureConfig.STRUCTURE_NAMES.Decorations5] = { title = "Decorations", cost = { gold = 7000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.KnightStatue1 } };
    [StructureConfig.STRUCTURE_NAMES.KnightStatue1] = { title = "Knight Statue", cost = { gold = 8000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Decorations6 } };
    [StructureConfig.STRUCTURE_NAMES.Decorations6] = { title = "Decorations", cost = { gold = 7000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Candelabras3 } };
    [StructureConfig.STRUCTURE_NAMES.Candelabras3] = { title = "Candelabras", cost = { gold = 3000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Banner5 } };
    [StructureConfig.STRUCTURE_NAMES.Banner5] = { title = "Banner", cost = { gold = 1000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Banner6 } };
    [StructureConfig.STRUCTURE_NAMES.Banner6] = { title = "Banner", cost = { gold = 1000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Banner7 } };
    [StructureConfig.STRUCTURE_NAMES.Banner7] = { title = "Banner", cost = { gold = 1000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Walls9 } };
    [StructureConfig.STRUCTURE_NAMES.Walls9] = { title = "Walls", cost = { gold = 1500 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Columns9 } };
    [StructureConfig.STRUCTURE_NAMES.Columns9] = { title = "Columns", cost = { gold = 1000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Doorway2 } };
    [StructureConfig.STRUCTURE_NAMES.Doorway2] = { title = "Doorway", cost = { gold = 2000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Fences2 } };
    [StructureConfig.STRUCTURE_NAMES.Fences2] = { title = "Fences", cost = { gold = 2000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.FlowerPots2 } };
    [StructureConfig.STRUCTURE_NAMES.FlowerPots2] = { title = "Flower Pots", cost = { gold = 2000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Chandeliers4 } };
    [StructureConfig.STRUCTURE_NAMES.Chandeliers4] = { title = "Chandeliers", cost = { gold = 3000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Carpet5 } };
    [StructureConfig.STRUCTURE_NAMES.Carpet5] = { title = "Carpet", cost = { gold = 2000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Wall6 } };
    [StructureConfig.STRUCTURE_NAMES.Wall6] = { title = "Wall", cost = { gold = 4000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Walls10 } };
    [StructureConfig.STRUCTURE_NAMES.Walls10] = { title = "Walls", cost = { gold = 3000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Columns10 } };
    [StructureConfig.STRUCTURE_NAMES.Columns10] = { title = "Columns", cost = { gold = 4000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Windows6 } };
    [StructureConfig.STRUCTURE_NAMES.Windows6] = { title = "Windows", cost = { gold = 5000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.SwordAndShield2 } };
    [StructureConfig.STRUCTURE_NAMES.SwordAndShield2] = { title = "Sword & Shield", cost = { gold = 6000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Knight2 } };
    [StructureConfig.STRUCTURE_NAMES.Knight2] = { title = "Knight", cost = { gold = 6000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Candelabras4 } };
    [StructureConfig.STRUCTURE_NAMES.Candelabras4] = { title = "Candelabras", cost = { gold = 3000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Banner8 } };
    [StructureConfig.STRUCTURE_NAMES.Banner8] = { title = "Banner", cost = { gold = 1000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Banner9 } };
    [StructureConfig.STRUCTURE_NAMES.Banner9] = { title = "Banner", cost = { gold = 1000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Banner10 } };
    [StructureConfig.STRUCTURE_NAMES.Banner10] = { title = "Banner", cost = { gold = 1000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Decorations7 } };
    [StructureConfig.STRUCTURE_NAMES.Decorations7] = { title = "Decorations", cost = { gold = 7000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.KnightStatue2 } };
    [StructureConfig.STRUCTURE_NAMES.KnightStatue2] = { title = "Knight Statue", cost = { gold = 8000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Decorations8 } };
    [StructureConfig.STRUCTURE_NAMES.Decorations8] = { title = "Decorations", cost = { gold = 7000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.CastleTower3 } };
    [StructureConfig.STRUCTURE_NAMES.CastleTower3] = { title = "Castle Tower", cost = { gold = 5000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Doorway3 } };
    [StructureConfig.STRUCTURE_NAMES.Doorway3] = { title = "Doorway", cost = { gold = 2000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Floor2 } };
    [StructureConfig.STRUCTURE_NAMES.Floor2] = { title = "Floor", cost = { gold = 2000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Fence1 } };
    [StructureConfig.STRUCTURE_NAMES.Fence1] = { title = "Fence", cost = { gold = 2000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Stairs1 } };
    [StructureConfig.STRUCTURE_NAMES.Stairs1] = { title = "Stairs", cost = { gold = 2000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Stairs2 } };
    [StructureConfig.STRUCTURE_NAMES.Stairs2] = { title = "Stairs", cost = { gold = 2000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Wall7 } };
    [StructureConfig.STRUCTURE_NAMES.Wall7] = { title = "Wall", cost = { gold = 2000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Stairs3 } };
    [StructureConfig.STRUCTURE_NAMES.Stairs3] = { title = "Stairs", cost = { gold = 2000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Floor3 } };
    [StructureConfig.STRUCTURE_NAMES.Floor3] = { title = "Floor", cost = { gold = 2000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Stairs4 } };
    [StructureConfig.STRUCTURE_NAMES.Stairs4] = { title = "Stairs", cost = { gold = 2000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Fence2 } };
    [StructureConfig.STRUCTURE_NAMES.Fence2] = { title = "Fence", cost = { gold = 2000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.Doorway4 } };
    [StructureConfig.STRUCTURE_NAMES.Doorway4] = { title = "Doorway", cost = { gold = 2000 }, purchaseable = { StructureConfig.STRUCTURE_NAMES.CastleTower4 } };
    [StructureConfig.STRUCTURE_NAMES.CastleTower4] = { title = "Castle Tower", cost = { gold = 5000 }, purchaseable = { } };
}

return StructureConfig
