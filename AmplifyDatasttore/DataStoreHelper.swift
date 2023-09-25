//
//  DataStoreHelper.swift
//  AmplifyDatasttore
//
//  Created by David Perez Espino on 22/09/23.
//

import Amplify

class DataStoreHelper {
    
    func changeSync() async {
        do {
            try await Amplify.DataStore.stop()
            print("DataStore stopped")
            try await Amplify.DataStore.start()
            print("DataStore started")
        } catch let error as DataStoreError {
            print("Failed with error \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
    }
    
    func startSync() async {
        do {
            try await Amplify.DataStore.start()
            print("DataStore started")
        } catch let error as DataStoreError {
            print("Failed with error \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
    }
    
    func stopSync() async {
        do {
            try await Amplify.DataStore.stop()
            print("DataStore started")
        } catch let error as DataStoreError {
            print("Failed with error \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
    }
    
    func addPost(post: Post) async -> Bool {
        
        do {
            try await Amplify.DataStore.save(post)
            print("Post saved successfully!")
            return true
        } catch let error as DataStoreError {
            print("Error saving post \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
        
        return false
    }
    
    func getPost(id: String) async -> Post? {
        
        do {
            let result = try await Amplify.DataStore.query(Post.self, byId: id)
            print("Post: \(result)")
            return result
        } catch {
            print("Error on query() for type Post - \(error)")
        }
        
        return nil
    }
    
    func getPosts() async -> [Post]? {
        
        do {
            let posts = try await Amplify.DataStore.query(Post.self)
            print("Posts retrieved successfully: \(posts)")
            return posts
        } catch let error as DataStoreError {
            print("Error retrieving posts \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
        
        return nil
    }
    
    func updatePost(existingPost: Post) async -> Bool {
        
        /*existingPost.title = "[updated] My first post"*/
        
        do {
            try await Amplify.DataStore.save(existingPost)
            print("Updated the existing post")
            return true
        } catch let error as DataStoreError {
            print("Error updating post - \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
        
        return false
    }
    
    func deletePost(post: Post) async -> Bool {
        
        do {
            try await Amplify.DataStore.delete(post)
            print("Post deleted!")
            return true
        } catch let error as DataStoreError {
            print("Error deleting post - \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
        
        return false
    }
    
    func deletePostById(id: String) async -> Bool {
        
        do {
            try await Amplify.DataStore.delete(Post.self, withId: id)
            print("Post deleted!")
            return true
        } catch let error as DataStoreError {
            print("Error deleting post - \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
        
        return false
    }
    
}
