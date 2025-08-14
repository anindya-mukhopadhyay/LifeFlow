List(ngos) { ngo in
    VStack(alignment: .leading, spacing: 6) {
        Text(ngo.name).font(.headline)
        Text("Email: \(ngo.email)").font(.subheadline).foregroundColor(.gray)
        Text("Phone: +91 \(ngo.phone)").font(.subheadline).foregroundColor(.gray)
        Text("Address: \(ngo.address)").font(.subheadline).foregroundColor(.gray)
        Text("Website: \(ngo.website)").font(.subheadline).foregroundColor(.blue)
        Text("Contact Person: \(ngo.contactPerson)").font(.subheadline).foregroundColor(.gray)
        
        if !ngo.certificates.isEmpty {
            Text("Certificates:").font(.subheadline).fontWeight(.semibold)
            ForEach(ngo.certificates) { cert in
                Text("\(cert.name) - \(cert.number)").font(.footnote).foregroundColor(.gray)
            }
        }
    }
    .padding(.vertical, 4)
}
