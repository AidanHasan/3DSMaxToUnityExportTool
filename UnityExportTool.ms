rollout exportTool "Unity Export Tool"
(
    -- UI Elements
    button btnExport "Export FBX" width:150 height:40
    checkbox chkTextures "Include Textures"
    checkbox chkSelected "Export Selected Only"

    -- Function: Export FBX with Unity-compatible settings
    fn exportFBX filePath = (
        -- Set FBX export parameters
        fbxExporterSetParam "UpAxis" "Y"
        fbxExporterSetParam "ExportAnimation" false
        fbxExporterSetParam "PreserveInstances" true
        fbxExporterSetParam "EmbedTextures" chkTextures.state
        fbxExporterSetParam "AxisConversionMethod" "None"
        fbxExporterSetParam "GenerateLog" false

        -- Perform the export
        exportFile filePath #noPrompt using:FBXEXP
    )

    -- Function: Convert all materials to Unity-compatible PBR
    fn convertMaterialsToPBR = (
        for mat in scenematerials do (
            if (classof mat == StandardMaterial) then (
                -- Create a new PhysicalMaterial for PBR
                newMat = PhysicalMaterial()
                newMat.baseColor = mat.diffuse
                newMat.metalness = 0.0
                newMat.roughness = 0.5

                -- Replace old material with new PBR material
                replaceInstances mat newMat
            )
        )
    )

    -- Event: On Export Button Press
    on btnExport pressed do (
        local path = getSaveFileName caption:"Save FBX As" types:"FBX(*.fbx)|*.fbx|"
        if path != undefined do (
            convertMaterialsToPBR()
            if chkSelected.state then (
                exportFile path #noPrompt selectedOnly:true using:FBXEXP
            ) else (
                exportFBX path
            )
            messageBox "Export Completed!" title:"Success"
        )
    )
)

-- Create the dialog
createDialog exportTool



--lmk of any issues, this was just a quickie(teehee)
