function Debug(...)
    if not Config.GarageSystem.debugMode then return end

    print("[DEBUG] " .. ...)
end

function TypeMustBe(variable, typeExpected)
    if not variable then return true end
    if not typeExpected then return end

    return type(variable) == typeExpected
end