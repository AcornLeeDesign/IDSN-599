//
//  SupabaseManager.swift
//  Touch and Gestures
//
//  Created by Aaron Lee on 10/2/25.
//
import SwiftUI
import Supabase

final class SupabaseService {
    static let shared = SupabaseService()
    
    let client: SupabaseClient
    
    private init() {
        let url = URL(string: "https://lcnmqvlnfdaadzitwbld.supabase.co")!
        let key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxjbm1xdmxuZmRhYWR6aXR3YmxkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk0NDc3MTgsImV4cCI6MjA3NTAyMzcxOH0.FqFY_opTC-7eH7RVIRmQxq8LhdxmK3Je2stu-tKqgvI"
        client = SupabaseClient(supabaseURL: url, supabaseKey: key)
    }
    
    func publicURL(for path: String, bucket: String = "videos") -> URL? {
        print("starting ")
        if path.starts(with: "http") { return URL(string: path) }
        let clean = path.hasPrefix("/") ? String(path.dropFirst()) : path
        let urlString = "https://collection-box.supabase.co/storage/v1/object/public/\(bucket)/\(clean)"
        return URL(string: urlString)
    }
}

