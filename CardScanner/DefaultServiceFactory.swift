//
//  DefaultServiceFactory.swift
//  CardScanner
//
//  Created by Luke Van In on 2017/02/18.
//  Copyright © 2017 Luke Van In. All rights reserved.
//

import Foundation
import GoogleNaturalLanguageAPI

struct DefaultServiceFactory: ServiceFactory {
    
    private let googleKey = "AIzaSyDTdcgltBmKzyR1n-eG2Vjc7L4vBBbpQ90"

    func imageAnnotationService() -> ImageAnnotationService? {
        return TestServiceFactory().imageAnnotationService()
    }
    
    func textAnnotationService() -> TextAnnotationService? {
        let googleNaturalLanguageService = GoogleNaturalLanguageAPI(key: googleKey)
        let googleNaturalLanguageServiceAdapter = GoogleNaturalLanguageServiceAdapter(service: googleNaturalLanguageService)
        let dataDetectorService = DataDetectorTextAnnotationService()
        return AggregateTextAnnotationService(
            services: [
                
                .descriptor(
                    service: googleNaturalLanguageServiceAdapter,
                    combine: { original, response in
                        return TextAnnotationResponse(
                            personEntities: response.personEntities,
                            organizationEntities: response.organizationEntities,
                            addressEntities: original.addressEntities,
                            phoneEntities: original.phoneEntities,
                            urlEntities: original.urlEntities,
                            emailEntities: original.emailEntities
                        )
                }),
                
                .descriptor(
                    service: dataDetectorService,
                    combine: { original, response in
                        TextAnnotationResponse(
                            personEntities: original.personEntities,
                            organizationEntities: original.organizationEntities,
                            addressEntities: response.addressEntities,
                            phoneEntities: response.phoneEntities,
                            urlEntities: response.urlEntities,
                            emailEntities: response.emailEntities
                        )
                })
            ]
        )
    }
    
    func addressResolutionService() -> AddressResolutionService? {
        return CoreLocationAddressResolutionService()
    }
}
