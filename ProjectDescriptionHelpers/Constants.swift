//
//  Constants.swift
//  DependencyPlugin
//
//  Created by HyunJin on 2022/05/22.
//

import ProjectDescription

public enum Constants {
    static var isDeploymentBuild: Bool {
        var result: Bool? = nil
        if case let .boolean(isProductionBuild) = Environment.riderAppProduction {
            result = isProductionBuild
        }
        if case let .boolean(isDeploymentBuild) = Environment.riderBuildForDeployment {
            result = isDeploymentBuild
        }
        guard let isDeploymentBuild = result else { fatalError("Environment variable TUIST_RIDER_BUILD_FOR_DEPLOYMENT is undefined") }
        return isDeploymentBuild
    }
}
