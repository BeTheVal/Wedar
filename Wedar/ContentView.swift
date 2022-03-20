//
//  ContentView.swift
//  Wedar
//
//  Created by Miguel Gutiérrez Pardo on 6/3/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @ObservedObject var weatherViewModel = WeatherViewModel()
    
    var body: some View {
        VStack{
            if weatherViewModel.isLoading {
                VStack{                 
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(2)
                }.onAppear(perform: self.weatherViewModel.getLatLong)
            } else{
                GeometryReader { geometry in
                    ZStack {
                        Image(weatherViewModel.background)
                            .resizable()
                            .aspectRatio(geometry.size, contentMode: .fill)
                            .edgesIgnoringSafeArea(.all)
                        VStack{
                            Spacer()
                            VStack{
                                
                                AsyncImage(url: URL(string: weatherViewModel.imageWeather ), content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: 100, maxHeight: 100)
                                },
                                           placeholder: {
                                    ProgressView()
                                })
                                Text(weatherViewModel.descriptionWeather).foregroundColor(weatherViewModel.textColor)
                                Text("\(weatherViewModel.celsius) ºC").font(.system(size: 60)).foregroundColor(weatherViewModel.textColor)
                                Text(weatherViewModel.cityName).foregroundColor(weatherViewModel.textColor)
                                Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: weatherViewModel.lat, longitude: weatherViewModel.lon), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))), interactionModes: [], showsUserLocation: true, userTrackingMode: .constant(.follow))
                                    .frame(width: 300, height: 200).cornerRadius(20)
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            
        }
    }
}


