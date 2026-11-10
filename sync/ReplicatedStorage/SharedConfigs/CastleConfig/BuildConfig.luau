local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AssetSharedService = require(ReplicatedStorage.SharedServices.AssetSharedService)

local BuildConfig = {}

BuildConfig.CATEGORY_NAMES = {
    All = "All";
    Decor = "Decor";
    Nature = "Nature";
    Special = "Special";
}

BuildConfig.BUILD_NAMES = {
    -- decor
    GoldLionStatue = "GoldLionStatue";
    MarbleLionStatue = "MarbleLionStatue";
}
BuildConfig.BUILD_TO_ASSET = {
    -- decor
    [BuildConfig.BUILD_NAMES.GoldLionStatue] = AssetSharedService.BuildAssets["Gold Lion Statue"];
    [BuildConfig.BUILD_NAMES.MarbleLionStatue] = AssetSharedService.BuildAssets["Marble Lion Statue"];
}
BuildConfig.BUILD_TO_LIST_ORDER = {
    -- decor
    [BuildConfig.BUILD_NAMES.GoldLionStatue] = 1;
    [BuildConfig.BUILD_NAMES.MarbleLionStatue] = 2;
}
BuildConfig.BUILD_TO_PUBLIC_NAME = {
    -- decor
    [BuildConfig.BUILD_NAMES.GoldLionStatue] = "Gold Lion Statue";
    [BuildConfig.BUILD_NAMES.MarbleLionStatue] = "Marble Lion Statue";
}
BuildConfig.CATEGORY_TO_BUILDS = {
    [BuildConfig.CATEGORY_NAMES.All] = {
        
    };
    [BuildConfig.CATEGORY_NAMES.Decor] = {
        BuildConfig.BUILD_NAMES.GoldLionStatue;
        BuildConfig.BUILD_NAMES.MarbleLionStatue;
    };
    [BuildConfig.CATEGORY_NAMES.Nature] = {
        
    };
    [BuildConfig.CATEGORY_NAMES.Special] = {
       
    };
}

return BuildConfig
