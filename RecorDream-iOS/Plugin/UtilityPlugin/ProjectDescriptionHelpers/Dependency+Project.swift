//
//  Dependency+Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Junho Lee on 2022/09/21.
//

import ProjectDescription

public extension TargetDependency {
    public struct Project {}
}

public extension TargetDependency.Project {
    static let RDNavigator = TargetDependency.project(target: "RD-Navigator", path: .relativeToRoot("Projects/Modules/RD-Navigator"))
    
    static let RDPresentation = TargetDependency.project(target: "Presentation", path: .relativeToRoot("Projects/Presentation/Presentation"))
    
    static let RDCore = TargetDependency.project(target: "RD-Core", path: .relativeToRoot("Projects/Core/RD-Core"))
    
    static let RDData = TargetDependency.project(target: "Data", path: .relativeToRoot("Projects/Data/Data"))
    
    static let RDDomain = TargetDependency.project(target: "Domain", path: .relativeToRoot("Projects/Domain/Domain"))
    
    static let RDNetwork = TargetDependency.project(target: "RD-Network", path: .relativeToRoot("Projects/Modules/RD-Network"))
    static let RDDSKit = TargetDependency.project(target: "RD-DSKit", path: .relativeToRoot("Projects/Modules/RD-DSKit"))
    static let RDThridPartyLib = TargetDependency.project(target: "ThirdPartyLib", path: .relativeToRoot("Projects/Modules/ThirdPartyLib"))
    static let RDUtilKit = TargetDependency.project(target: "RD-UtilKit", path: .relativeToRoot("Projects/Modules/RD-UtilKit"))
    static let RDUser = TargetDependency.project(target: "RD-User", path: .relativeToRoot("Projects/Modules/RD-User"))
    static let RDAnalytics = TargetDependency.project(target: "RD-Analytics", path: .relativeToRoot("Projects/Modules/RD-Analytics"))
}