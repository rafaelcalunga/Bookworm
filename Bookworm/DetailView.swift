//
//  DetailView.swift
//  Bookworm
//
//  Created by Rafael Calunga on 2020-10-22.
//

import SwiftUI
import CoreData

struct DetailView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    let book: Book
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(book.genre ?? "Fantasy")
                        .frame(maxWidth: geometry.size.width)
                    
                    Text(book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                
                Text(book.author ?? "Unknown review")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Text(book.review ?? "No review")
                    .padding()
                
                RatingView(rating: .constant(Int(book.rating)))
                    .font(.largeTitle)
                
                if let date = book.date {
                    Text("\(date, formatter: dateFormatter)")
                        .foregroundColor(.secondary)
                        .padding()
                }
                
                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"))
        .navigationBarItems(trailing: Button(action:{ self.showingDeleteAlert = true }) {
            Image(systemName: "trash")
        })
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete book"),
                  message: Text("Are you sure?"),
                  primaryButton: .destructive(Text("Delete")) { self.deleteBook() },
                  secondaryButton: .cancel())
        }
    }
    
    func deleteBook() {
        context.delete(book)
        
        try? context.save()
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let book = Book(context: context)
        book.author = "Arthur Conan Doyle"
        book.title = "A Study in Scarlet"
        book.genre = "Mystery"
        book.rating = 5
        book.review = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi dui neque, efficitur sit amet ipsum sed, consectetur sagittis risus."
        book.date = Date()
        
        return NavigationView {
            DetailView(book: book)
        }
    }
}
