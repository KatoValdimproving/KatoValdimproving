//
//  ArtWalkExtensions.swift
//  hfciPatientX
//
//  Created by developer on 30/10/21.
//

import Foundation
import UIKit
import Mappedin





func getBeaconByMayorAndMinor(mayor: Int, minor: Int) -> Beacon? {
    print("Searched \(mayor)")

    let beaconFound = beacons.filter { be in
        print(be.mayor)
       return be.mayor == mayor
    }
    if beaconFound.count > 0 {
        if let beacon = beaconFound.first {
            print("🍥 \(beacon.mayor)")
            return beacon
        }
    }
    
    return nil
}

func getBeaconByPaintiingTitle(title: String) -> Beacon? {
    
    let beaconFound = beacons.filter { beacon in
        return beacon.paintings[0].title == title
    }
    
    if beaconFound.count > 0 {
        if let beacon = beaconFound.first {
            return beacon
        }
    }
    
    return nil
    
}
let paintings: [Painting] = [
    
    Painting(name: "1", title: "Calendar", author: "Friedel Dzubas", text: """
Magna acrylics on canvas

Color Field painter Friedel Dzubas was a pioneer of the stain painting technique alongside 20th century painters, Helen Frankenthaler, Morris Louis, and Kenneth Noland. His earliest works evoked Paul Klee, but he soon moved towards working exclusively in colorful stain painting. He applied paint in a thin, texturally uniform manner creating fields of dense color and other areas where the color seemed almost translucent. For Dzubas, these paintings referenced natural phenomena, emotion, the painterly gesture, and the experience of color itself. Dzubas had a prolific art career that spanned nearly five decades.

These paintings are part of a seventeen-canvas installation. The others are displayed at Henry Ford Health System’s Royal Oak Medical Center
""", origin: "German/American", technique: "", year: "1915-1994", location: "Calendar by Friedel Dzubas"),
    
    Painting(name: "2", title: "Simbiosis", author: "Juan Carlos Martinez", text: """
Simbiosis is a custom hanging sculpture created especially for the Brigitte Harris Cancer Pavilion. The sculpture features several imagined flying forms and seed pods inspired by the artist’s trip to Colombia. The artist utilized several different metalworking techniques to create each unique form and used interference acrylic paint with Micah flakes to produce the iridescent effect.

Juan creates sculptures that live and work among us, drawing from his experience as a science illustrator and fabricator working with metal, wood, and other materials. His work has been exhibited at Art Basel Miami, Museum of Contemporary Art Detroit (MOCAD), and in public and community spaces in Detroit, Los Angeles, and New York.  Juan’s artistic practice is informed by his commitment to community, with an emphasis on empowering and equipping Detroit youth for extraordinary futures.
""", origin: "Detroit, Michigan", technique: "Cast and hammered aluminum, stainless steel, bronze", year: "2020", location: "Simbiosis by Juan Carlos Martinez"),
    
    
    Painting(name: "3", title: "Shared Blessings with Shared Visions", author: "Kevin Cole", text: """
Shared Blessings with Shared Visions is a custom artwork that honors the life and love story of Brigitte and Mort Harris. As a caring and compassionate wife and mother, Brigitte made major contributions to numerous arts and service organizations. She was also an avid tennis player and rose gardener. Through this work, the artist conveys her energy, and the love she had for her husband, family, and her community.
African symbols and patterns that symbolize faith, dreams, love, strength, perseverance, and hope are etched into the necktie and scarf shapes. The color forms symbolize the ups and downs we may experience yet through it all we keep finding the energy to press on, realizing with faith there are brighter days are ahead.
This sculpture is an extension of Cole’s Fragments of Frozen Sound Series, which makes use of various shapes and forms taken from the process of mapping. Underneath the tie and scarf shapes are map shapes of places where Brigitte lived including, Aachen, Germany, London, New York, San Francisco, Chicago, Stockholm, and Detroit. These shapes come together to combine with where her husband Mort was born, and where the two of them met and spent their lives together.
Kevin Cole is an Atlanta-based painter and mixed-media artist. Cole was born in Pine Bluff, Arkansas, and remains active in Atlanta, Georgia, and nationally. Cole was named Georgia State Artist of the Year in 1996 and has completed over 35 public art commissions, including the Coca-Cola Centennial Olympic Mural for the 1996 Olympic games and “Soul Ties That Matter,” a 55-foot-long installation created for Hartsfield-Jackson Atlanta International Airport in 2018. The artist’s work is included in more than 3,600 public, private, and corporate collections throughout the United States, including the National Museum of African American History and Culture at the Smithsonian Museum in Washington, D.C.
Cole’s paintings, three-dimensional wooden and metal constructions, are recognizable due to his frequent use of the necktie as a motif, which alludes to both struggle and celebration in the African American experience.
""", origin: "Atlanta, GA", technique: "Shaped and etched aluminum, acrylic paint on tar paper", year: "2020", location: "Shared Visions with Shared Blessings by Kevin Cole"),
    
    
    Painting(name: "4", title: "A Series of Arrangements #2", author: "Tyanna Buie", text: """
Artist’s Statement:

“Inspired by positive and negative experiences that come with the foster care system, I was fortunate to find my voice, creative vision, and a connection with the outside world through the re-making of images.

The impermanence experienced has led me to create alternative perspectives based upon personal history.  Photo-based images, family memorabilia, and documents sourced from family members allow me to re-visit and revive previous impressions from past events.  Through a non-specific order of occurrence, these images begin to manifest into exaggerated accounts that are inconsistent from one event to another.  The use of traditional narrative and non-narrative aspects of storytelling is evident in the work, which allows me to challenge my family’s past, to re-imagine the future through fragmentation.

Repetition, dissemination, and the building of images in the work allows me to combine methods such as, painting, drawing, collage, and screen-printing, in a non-traditional manner on multi-sheets of paper, while creating singular pieces as well as large-scale site-specific installations.  These techniques enable me to work intuitively in multiple facets by distressing, excavating, and re-working the surface to ultimately reveal an unspecified narrative that become either isolated depictions, or re-configured images that transform the perception of space.”

Artist Bio:

A Chicago and Milwaukee native, Tyanna received her B.A from Western Illinois University, and her MFA from the University of Wisconsin-Madison. In 2012, Buie received an emerging artist Mary L. Nohl Fellowship and is the recipient of a 2015 Joan Mitchell Foundation Painters & Sculptors Grant and the 2015 Love of Humanity Award from the Greater Milwaukee Foundation. Her work is currently on view in the collection of the Milwaukee Art Museum as part of the permanent collection. Buie currently lives and works in Detroit, MI, where she is an Assistant Professor/ Section Chair of Printmaking at the College for Creative Studies.
""", origin: "Detroit, Michigan", technique: "Screenprint, Caran d'Ache, hand-cut paper, monotype on paper", year: "2020", location: "A Series of Arrangements #2 by Tyanna\tBuie"),
    
    
    Painting(name: "5", title: "Rust and Roses", author: "Johanna Curwood", text: """
Johanna Curwood is an Australian artist based in the United States who works in the spaces connecting color, light, texture, shadow, movement, and all that’s in-between.
""", origin: "Detroit, Michigan", technique: "Hand-sculpted mixed media layerings, pigmented and reactive resin, gold foil, signature survivor cardboard leaves on metal", year: "2020", location: "Rust and Roses by Johanna Curwood"),
    
    Painting(name: "6", title: "Untitled", author: "James Collins", text: """
Employing process as content, Detroit-based artist James Collins produces graphic line paintings that resemble warped photocopies and moiré patterns. His multidimensional line-heavy works are created using a chance-based, custom process in which oil paint and water-based acrylic interact in a fluid state and repel each other. Relying on a precise chemical balance, Collins allows his materials to dictate their own outcomes. Though this technique, he can create entire paintings in one sitting. His goal, he has said, is not to create new imagery but to breathe new life into painting by giving art-making materials command over the resulting artwork. Collins’s earlier works involved layers of white and silver house paint wrapped in plastic wrap to add texture and allowed to flake and peel over time.
""", origin: "Detroit, Michigan", technique: "Oil on canvas and acrylic on vinyl", year: "", location: "Untitled by James Collins"),
    
    
    Painting(name: "7", title: "The Russell", author: "Darcel Deneau", text: """
Artist’s Statement:

“After the devastating death of my father and the near death of my mother in a home invasion shooting in a quiet suburban community; life as I knew it had changed forever. This unimaginable event gave me a harsh realization that life was short, and incidentally became the catalyst that inspired me. I reflected on my own life and how I had lived it up to now. Who would I be remembered as? A wife? A mother?

 Suddenly, I had clarity for my life's purpose, and I decided to make art a greater part of my life.

 Although I considered myself an artist since a young age and creativity had been a daily part of my life; I had not yet concentrated on developing my creative abilities.

With two school-age children, I enrolled as a full-time student at the College for Creative Studies, CCS.

Detroit inspired me. Initially I became fascinated with painting images of the city as it took me back to spending time with my father in places like Eastern Market, Downtown, Mexicantown, the Riverfront and more. I soon found my affection for the city was not shared by many of my fellow metro-Detroiters; not even the press.

A negative perception of Detroit was apparent and fueled my drive to validate the city's worth even more. Today I continue to paint positive images of this truly amazing city.” – Darcel Deneau

The Russell Industrial Center is an industrial factory turned to commercial complex of studios and shops that is located at 1600 Clay Street in Detroit, Michigan. The Russell Industrial Center is a 2,200,000-square-foot (200,000 m2), seven building complex designed by Albert Kahn for John William Murray in 1915. It contains studios and lofts and serves as a professional center for commercial and creative arts.
""", origin: "Detroit, Michigan", technique: "Glass mosaic", year: "", location: "The Russell by Darcel Deneau"),
    
    
    Painting(name: "8", title: "Josephine Ford and Brigitte Harris", author: "Desiree Kelly", text: """
Desiree Kelly is an award-winning artist and a native to Detroit. She was introduced to oil painting while studying Graphic Design at Wayne State University. Raised on the Eastside, she is inspired by the environment and has developed a style of storytelling through portraits. Her portraits of public icons are historically immersive & reflect on the narrative of her subjects by including artifacts & phrases within each piece. She is known for her distinctive mixture of “street art” & traditional oil technique.

Kelly’s work can be seen in the Coleman A. Young Municipal Building (Mayor's office), dPoP!, Kuzzo's Chicken & Waffles, Eastern Market & the historical Alger Theater in Detroit. Her work is also in the permanent collections of the Charles H Wright Museum of African American History and Flint Institute of Arts. Her work has been published in the Washington Post and she has been commissioned by a number of private collections and public corporations which include Pepsi, Pandora (jewelry), Detroit Pistons, The Ellen DeGeneres Show, Converse, Kroger & Foot Locker.
""", origin: "Detroit, Michigan", technique: "Oil, spray paint, acrylic, on canvas", year: "2020", location: "Brigitte Harris and Josephine Ford by Desiree Kelly"),
    
    
    Painting(name: "9", title: "The DNA of Hope", author: "Erik and Israel Nordin, Detroit Design Center", text: """
Brothers, Erik and Israel Nordin have been working together to create one-of-a-kind sculptures and objects for indoor and outdoor spaces for over 20 years. They are the founders of Detroit Design Center and make one-of-a-kind statement pieces using glass, metal, wood, and other mediums.

Erik Nordin studied music at the University of Michigan and Israel Nordin studied ceramics and glass at the College for Creative Studies. Through their years of working together, their artistic differences and individual points of view have created balance in their approach and how they work with their clients.

Their 12,000 square foot studio space on Michigan Avenue in Detroit provides the space required to create large scale metal sculptures that they maneuver with the two cranes residing in their workspace.

Although they started with small scale pieces, their work has gotten bigger and bolder over the years and can now be seen all over the city of Detroit and throughout the state of Michigan. Each piece of sculpture is unique and tells a specific story.
""", origin: "Detroit, Michigan", technique: "Stainless steel, hand-cast glass, etched walnut, with reclaimed church organ pipes and wooden beam", year: "2020", location: "The DNA of Hope – Donor Wall"),
    
    
    Painting(name: "10", title: "Sway", author: "Susan Goethel Campbell", text: """
Susan Goethel Campbell creates multi-disciplinary work that considers landscape to be an emergent system where nature, culture and the engineered environment are indistinguishable from one another. Central to her practice is the collection, documentation and observation of seasonal change and ephemera in both natural and artificial environments. Her work is realized in several formats, including installation, video, prints and drawings, as well as projects that engage communities to look at local and global environments.

Campbell earned an MFA in printmaking from Cranbrook Academy of Art. Her work has been exhibited internationally in Belgium, Germany, Switzerland and Slovenia and nationally throughout the US, including, National Museum of Women in the Arts, Queens Art Museum, Crystal Bridges Museum, Museum of Contemporary Art Detroit, Grand Rapids Art Museum, the Detroit Institute of Arts, The Drawing Center, and The International Print Center New York. In 2009 she was one of 18 artists selected for the inaugural Kresge Artist Fellowship.

Campbell has been awarded residencies at the Banff Centre for the Arts, Flemish Center for Graphic Arts, the Jentel Foundation, Beisinghoff Print residency and the Print Research Institute of North Texas. She taught studio art for 15 years at the College for Creative Studies in Detroit and has been a visiting artist in numerous institutions in the United States and abroad. Her work is in the collection of the National Museum of Women in the Arts, New York Public Library, Detroit Institute of Arts, Toledo Museum of Art and the University of Michigan Special Collections Library.
""", origin: "Ferndale, Michigan", technique: "5 woodblock prints on panels, 1 digital photo on dibond", year: "2020", location: "Sway by Susan Goethel Campbell"),
    
    
    
//    Painting(name: "11", title: "Rags and Old Iron", author: "Carole Harris", text: """
//Carole Harris is a fiber artist who extends the boundaries of traditional quilting by exploring other forms of stitchery, irregular shapes, textures, materials, and objects. Her mother introduced her to needle arts at an early age, teaching her embroidery and crochet. It wasn’t until she received her BFA in art from Wayne State University in 1966 that she began to explore fibers as an art form.
//Carole is captivated by the interplay of hue and pattern, often drawing inspiration from the color, energy, movement, and rhythms of ethnographic rituals and textiles: as well as the music of and changing rhythms and history of the city of Detroit where she lives with her husband, Bill.
//Her process involves using commercially printed cottons, silks, hand-dyed and vintage fabrics, which she alters by overdyeing or painting. Carole often employs found objects, paper, rust dyeing, collage and even burning as techniques. These materials are cut up, overlaid, and repositioned creating a densely layered collage, with the top layer finished with hand-embroidery.
//“I now draw inspiration from walls, aging structures and objects that reveal years of use. My intention is to celebrate the beauty in the frayed, the decaying and the repaired. I want to capture the patina of color softened by time, as well as feature the nicks, scratches, scars, and other marks left by nature or humans on constructed and natural surfaces. I want to interpret these changes and tell these stories of time, place and people in cloth, using creative stitching, layering and the mixing of colorful and textured fabrics.”  - Carole Harris
//""", origin: "Detroit, Michigan", technique: "Mixed media collage", year: "", location: "1 West Check in: Radiation Oncology and Treatment Center"),
    
    
//    Painting(name: "12", title: "Lakeside Ride", author: "Bowen Kline", text: """
//Artist’s Statement:
//“I believe as an artist it is my duty to allow my inspiration to lead me. I do portraiture because it helps me understand where I fit in and I realize we all have experienced the same ups and downs. We are all the same. My cityscapes further this connection through spatial relationships. I’ve always been an introvert and the one way I know I can communicate is through my art. I am always absorbing the world around me. Nothing is out of bounds. Who am I as an artist? I am a reflection of everything because I am inspired by everything.” – Bowen Kline
//""", origin: "Romeo, Michigan", technique: "Mixed media on panel", year: "", location: "1 West Check in: Radiation Oncology and Treatment Center"),
    

//    Painting(name: "13", title: "Little Voice", author: "Deb Eyde", text: """
//Artist’s Statement:
//“Deborah Eyde has lived in the Midwest for most of her life. Pattern and repetition in the midwestern topography are common themes in her paintings. Farmland grids, lines painted on city streets and the more organic shapes of trees and foliage inform her work. Deborah works with encaustic paint and enjoys its unpredictable nature. Working with hot wax and a blowtorch leads to unplanned results, forcing her to stay engaged and respond to what is unfolding in front of her. Although her paintings are spontaneous and intuitive, her final layers are design conscious with some level of structure. Deborah’s paintings represent her personal history with a universal relatability. Some of this history is revealed through sheer layers and scraping while other parts are concealed and private. Deborah loves to pain which is evident in her joyful, happy paintings.
//
//Deborah studied painting at the School of the Art Institute of Chicago and has been painting with beeswax and oil paint since 2014.
//""", origin: "Ann Arbor, Michigan", technique: "Encaustic ", year: "", location: "1 West Check in: Radiation Oncology and Treatment Center"),
    
    
    Painting(name: "11", title: "DIA Art Walk", author: "", text: """
The Brigitte Harris Cancer Pavilion features reproductions of artistic masterpieces in the Detroit Institute of Arts (DIA) collection as part of the DIA’s Inside|Out program. Inside|Out is a popular component of the DIA’s community engagement efforts. Over the past 12 years, the museum has partnered with more than 100 communities and engaged tens of thousands of residents with art in places where they live, work and play.

The featured artworks and their locations were carefully selected with consideration to the physical and emotional journeys patients and families experience. For example, works near the elevator aim to give people something to consider while they wait and soothe anxiety in advance of or after their appointments. Works in the waiting areas feature serene but hopeful imagery that speaks to the future, while works displayed along the Nancy Vlasic Skywalk that connects to Henry Ford Hospital are colorful and dynamic to capture visitors’ attention as they are in transit.

About the Detroit Institute of Arts:
The Detroit Institute of Arts (DIA), one of the premier art museums in the United States, is home to more than 60,000 works that comprise a multicultural survey of human creativity from ancient times through the 21st century. From the first Van Gogh painting to enter a U.S. museum (Self-Portrait, 1887), to Diego Rivera's world-renowned Detroit Industry murals (1932–33), the DIA’s collection is known for its quality, range, and depth. The DIA’s mission is to create opportunities for all visitors to find personal meaning in art.
""", origin: "", technique: "", year: "", location: "DIA Art Walk"),
    
    
    Painting(name: "12", title: "Healing Arts Gallery", author: "", text: """
The Wright & Cathy Lassiter Healing Arts Gallery hosts curated art exhibitions featuring artwork by Detroit-area artists and community partners, as well as annual patient and staff art shows. This is the only space in the pavilion where the artwork on display rotates throughout the year.
""", origin: "", technique: "", year: "", location: "Healing Arts Gallery"),
]

let beacons = [
   // Beacon(uuid: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, mayor: 4885, minor: 58900, firstContact: nil, time: 5, distance: 2, identifier: "Calendar", paintings: [getPaintingByTitle(title: "Calendar")], proximity: 0, rrsi: 0, location: ""),
  //  Beacon(uuid: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, mayor: 20545, minor: 5125, firstContact: nil, time: 5, distance: 1, identifier: "Simbiosis", paintings: [getPaintingByTitle(title: "Simbiosis")], proximity: 0, rrsi: 0, location: ""),
//   Beacon(uuid: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, mayor: 7509, minor: 50853, firstContact: nil, time: 100, distance: 4, identifier: "3", paintings: [], proximity: 0, rrsi: 0, location: ""),
//    Beacon(uuid: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, mayor: 19879, minor: 24862, firstContact: nil, time: 100, distance: 4, identifier: "4", paintings: [], proximity: 0, rrsi: 0, location: ""),
    
   
    Beacon(uuid: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, mayor: 35557, minor: 9601, firstContact: nil, time: 5, distance: 2, identifier: "Calendar", paintings: [getPaintingByTitle(title: "Calendar")], proximity: 0, rrsi: 0, location: ""),
    Beacon(uuid: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, mayor: 6814, minor: 5832, firstContact: nil, time: 5, distance: 5, identifier: "Simbiosis", paintings: [getPaintingByTitle(title: "Simbiosis")], proximity: 0, rrsi: 0, location: ""),
    Beacon(uuid: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, mayor: 454, minor: 21971, firstContact: nil, time: 5, distance: 5, identifier: "Shared Blessings with Shared Visions", paintings: [getPaintingByTitle(title: "Shared Blessings with Shared Visions")], proximity: 0, rrsi: 0, location: ""),
    Beacon(uuid: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, mayor: 23757, minor: 6314, firstContact: nil, time: 5, distance: 2, identifier: "A Series of Arrangements #2", paintings: [getPaintingByTitle(title: "A Series of Arrangements #2")], proximity: 0, rrsi: 0, location: ""),
    Beacon(uuid: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, mayor: 27400, minor: 48675, firstContact: nil, time: 5, distance: 2, identifier: "Untitled", paintings: [getPaintingByTitle(title: "Untitled")], proximity: 0, rrsi: 0, location: ""),
    Beacon(uuid: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, mayor: 35995, minor: 11128, firstContact: nil, time: 5, distance: 2, identifier: "The Russell", paintings: [getPaintingByTitle(title: "The Russell")], proximity: 0, rrsi: 0, location: ""),
    Beacon(uuid: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, mayor: 23068, minor: 6689, firstContact: nil, time: 5, distance: 2, identifier: "Josephine Ford and Brigitte Harris", paintings: [getPaintingByTitle(title: "Josephine Ford and Brigitte Harris")], proximity: 0, rrsi: 0, location: ""),
    Beacon(uuid: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, mayor: 23044, minor: 59833, firstContact: nil, time: 5, distance: 2, identifier: "The DNA of Hope", paintings: [getPaintingByTitle(title: "The DNA of Hope")], proximity: 0, rrsi: 0, location: ""),
    Beacon(uuid: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, mayor: 55859, minor: 64145, firstContact: nil, time: 5, distance: 3, identifier: "Sway", paintings: [getPaintingByTitle(title: "Sway")], proximity: 0, rrsi: 0, location: ""),
    Beacon(uuid: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, mayor: 43055, minor: 36490, firstContact: nil, time: 5, distance: 5, identifier: "DIA Art Walk", paintings: [getPaintingByTitle(title: "DIA Art Walk")], proximity: 0, rrsi: 0, location: ""),
    Beacon(uuid: UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!, mayor: 2297, minor: 50393, firstContact: nil, time: 5, distance: 5, identifier: "Healing Arts Gallery", paintings: [getPaintingByTitle(title: "Healing Arts Gallery")], proximity: 0, rrsi: 0, location: ""),
    
]


func asigBeaconsToPaintings() {
    
    for painting in paintings {
        
        for beacon in beacons {
            if beacon.identifier == painting.title {
                painting.beacon = beacon
            }
        }
        
    }
    
}

func getPaintingByTitle(title: String) -> Painting {
    let painting = paintings.filter { painting in
        return painting.title == title
    }
    return painting.first!
    
}

func getEntrance(allLocation: [MPILocation]) -> MPILocation? {
    let entrance = allLocation.filter { location in
        return location.id == "60186caad8ca2e0973000002"
    }
    
    if entrance.count > 0 {
        if let first = entrance.first {
            return first
        }
    }
    
    return nil
}


func imageForDirection(option: String) -> UIImage {
    
    if (option.range(of: "Turn right", options: .caseInsensitive, range: nil, locale: nil) != nil) {
        return UIImage(named: "turnRight") ?? UIImage()
    }
    if (option.range(of: "Turn left", options: .caseInsensitive, range: nil, locale: nil) != nil) {
        return UIImage(named: "turnLeft") ?? UIImage()
    }
    if (option.range(of: "Arrive", options: .caseInsensitive, range: nil, locale: nil) != nil) {
        return UIImage(named: "arrived") ?? UIImage()
    }
    if (option.range(of: "Stairs", options: .caseInsensitive, range: nil, locale: nil) != nil) {
        return UIImage(named: "stairs") ?? UIImage()
    }
    if (option.range(of: "Elevator", options: .caseInsensitive, range: nil, locale: nil) != nil) {
        return UIImage(named: "elevator") ?? UIImage()
    }
    if (option.range(of: "Turn slightly right", options: .caseInsensitive, range: nil, locale: nil) != nil) {
        return UIImage(named: "turnSlightlyRigth") ?? UIImage()
    }
    if (option.range(of: "Turn slightly left", options: .caseInsensitive, range: nil, locale: nil) != nil) {
        return UIImage(named: "turnSlightlyLeft") ?? UIImage()
    }
    if (option.range(of: "Go", options: .caseInsensitive, range: nil, locale: nil) != nil) {
        return UIImage(named: "go") ?? UIImage()
    }
    
    return UIImage(named: "myLocation") ?? UIImage()
}
