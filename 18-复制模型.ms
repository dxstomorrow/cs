PasteFile = getdir #autoback + @"\BorePaste\PasteFile.max"
theMaps = #()

fn Bore_GetClassIdToNode ApiClassID =
(
    (for o in texturemap.classes where o.classid[1] == ApiClassID[1] and o.classid[2] == ApiClassID[2] collect o)[1]
)
if VRayBitmap == undefined do VRayBitmap = Bore_GetClassIdToNode #(1734939723L, 46203261L)
if CoronaBitmap == undefined do CoronaBitmap = Bore_GetClassIdToNode #(2881116036L, 1699234372L)
if FStormBitmap == undefined do FStormBitmap = Bore_GetClassIdToNode #(437134346L, 913846139L)

if $ != undefined then
(
    MakeDir(getdir #autoback + @"\BorePaste\")
    try(deleteFile PasteFile) catch ()

    texarrary = #()
    -- 解析路径
    for o in selection where isProperty o #mat do 
    (
        for m in (getClassInstances bitmaptexture target:o) where (m.filename != undefined) and findItem texarrary m == 0 do append theMaps m
        if CoronaBitmap != undefined do (for m in (getClassInstances CoronaBitmap target:o) where (m.filename != undefined) and findItem texarrary m == 0 do append theMaps m)
        if FStormBitmap != undefined do (for m in (getClassInstances FStormBitmap target:o) where (m.filename != undefined) and findItem texarrary m == 0 do append theMaps m)
        if VRayBitmap != undefined do (for m in (getClassInstances VRayBitmap target:o) where (m.hdrimapname != undefined) and findItem texarrary m == 0 do append theMaps m)
    )

    for o in theMaps do 
    (
        if ClassOf o == VRayBitmap then 
        (
            filename = o.hdrimapname
            fullpath = mapPaths.getFullFilePath (filenameFromPath filename)
            if doesFileExist fullpath do o.hdrimapname = fullpath
        )
        else
        (
            filename = o.filename
            fullpath = mapPaths.getFullFilePath (filenameFromPath filename)
            if doesFileExist fullpath do o.filename = fullpath
        )
    )

    saveNodes $ PasteFile
)
