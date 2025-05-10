import SwiftUI

struct LocationSelectionView: View {
    @State private var selectedLocation: ArcadeLocation?
    @State private var showingForumView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("選擇機舖")
                        .font(.system(size: 32, weight: .bold))
                        .padding(.top, 40)
                    
                    ForEach(ArcadeLocation.allCases, id: \.self) { location in
                        NavigationLink(destination: ContentView(viewContext: PersistenceController.shared.container.viewContext, selectedLocation: location)) {
                            LocationCard(location: location)
                        }
                    }
                }
                .padding()
            }
            .withDefaultBackground()
            .navigationBarHidden(true)
        }
    }
}

struct LocationCard: View {
    let location: ArcadeLocation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(location.displayName)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.blue)
                Text("查看討論區")
                    .foregroundColor(.secondary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(radius: 5)
        )
        .padding(.horizontal)
    }
}

#Preview {
    LocationSelectionView()
} 