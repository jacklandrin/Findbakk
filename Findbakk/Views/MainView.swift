//
//  ContentView.swift
//  Findbakk
//
//  Created by jack on 2021/3/4.
//

import SwiftUI
import MapKit

struct MainView: View {
    @ObservedObject var geoInfo = GeoInfoViewModel()
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 52.3284912109375, longitude: 4.957738816192544), span: MKCoordinateSpan(latitudeDelta: defaultDelta, longitudeDelta: defaultDelta))
    @State var isShownCard:Bool = false
    @State var cardY:CGFloat = 1000.0
    @State var isDraggingCard = false
        
    var body: some View {
        ZStack {
            Map(coordinateRegion: $geoInfo.region, showsUserLocation:true, userTrackingMode:$geoInfo.trackingMode, annotationItems:geoInfo.places) { place in
                    MapAnnotation(coordinate: place.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                        LostAnnotation(imageTitle: place.imageTitle, controlInfoCard: {
                            self.isShownCard = true
                            withAnimation{
                                self.cardY = 0.0
                            }
                        })
                    }
            }
            .onReceive(geoInfo.objectWillChange) { _ in
                    getRegion()
                }
            
                .edgesIgnoringSafeArea(.all)
            .disabled(isShownCard)
            
            VStack {
                HStack {
                    Button(action: {}, label: {
                        Circle().overlay(
                            Image("Hamburger")
                                .resizable()
                                .scaledToFill()
                                .padding(6)
                        )
                    }).frame(width: 40, height: 40)
                    Spacer()
                    Button(action: {}, label: {
                        Circle().overlay(
                            Image("Post")
                                .resizable()
                                .scaledToFill()
                                .padding(6)
                        )
                    }).frame(width: 40, height: 40)
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {geoInfo.backMyLocation()}, label: {
                        Circle().overlay(
                            Image("Location")
                                .resizable()
                                .scaledToFill()
                                .padding(6)
                        )
                    }).frame(width: 40, height: 40)
                }
            }.padding(20)
            
            LostInfoCard()
                .frame(minWidth:200, minHeight: 400)
                .padding(EdgeInsets(top: 120, leading: 60, bottom: 120, trailing: 60))
                .hidden(!self.isShownCard)
                .offset(y: cardY)
                .onAnimationCompleted(for: cardY) {
                    if cardY == 0.0 {
                        return
                    }
                    self.isShownCard = false
                }
                .gesture(DragGesture().onChanged{ gesture in
                    self.isDraggingCard = true
                    let offsetY = gesture.translation.height
                    
                    self.cardY = offsetY

                }
                .onEnded{ gesture in
                    self.isDraggingCard = false
                    let offsetY = gesture.translation.height
                    
                    if offsetY > 40.0 {
                        withAnimation{
                            self.cardY = 1000.0
                        }
                        
                    } else {
                        withAnimation{
                            self.cardY = 0.0
                        }
                    }
                })
            
        }
        
    }
    
    func getRegion() {
        geoInfo.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: geoInfo.latitude, longitude: geoInfo.longitude), span: MKCoordinateSpan(latitudeDelta: geoInfo.latitudeDelta, longitudeDelta: geoInfo.longitudeDelta))
        
    }
}

struct LostAnnotation:View {
    @State var imageTitle:String
    var controlInfoCard:() -> Void
    var body: some View {
        Button(action: {
            self.controlInfoCard()
        }, label: {
            ZStack {
                Image("Bubble")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .colorMultiply(.blue)
               
                Image(imageTitle)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding(.bottom, 16)
                }
        })
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
