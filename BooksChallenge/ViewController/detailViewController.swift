//
//  detailViewController.swift
//  Merli
//
//  Created by Jésica González Baqué on 22/05/2021.
//

import UIKit
import ImageSlideshow

/*
 Abrir el terminal y situarse en la raíz del proyecto (donde este .xcodeproject)
 sudo gem install cocoapods
 pod repo update
 pod update
 ----Ahora editar el archivo PodFile y agregarle los pods que quieras---
 pod init
 ----Cerrás el project y a partir de ahora trabajás con el .xcodeworkspace---
 */

class detailViewController: UIViewController {

    @IBOutlet weak var detailScrollView: UIScrollView!
    
    @IBOutlet weak var Labeltitulo: UILabel!
    @IBOutlet weak var Image: UIImageView!
    
    var myProduct:Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = myProduct?.nombre
        //priceLabel.text = String(myProduct?.price ?? 0)
        
        self.Labeltitulo.text = myProduct?.nombre
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        detailScrollView.contentSize = CGSize(width:screenWidth, height: 2000)
        /* @@@@ Arreglar @@@@
        let registro = booksFiltered[indexPath.row]
        Labeltitulo.text = registro.nombre
        Image.image  = nil */
        
        loadImages()
    }
    
    func loadImages()
    {
        /*
        guard let picURL = URL(string: myProduct?.thumbnail ?? "") else { return }
        let session = URLSession(configuration: .default)
        let downloadTask = session.dataTask(with: picURL ) { (data, response, error) in
            if let e = error {
                print("Error" + e.localizedDescription)
            } else {
               // print("Descargada ok!")
                if let res = response as? HTTPURLResponse {
                    if let imageData = data {
                        print("Creada imagen ok!")
                        // Ejecuto en el main thread la asignación de la imagen, detener y ocultar el reloj.
                        DispatchQueue.main.async {
                            self.img1.image =  UIImage(data: imageData)
                            self.img2.image =  UIImage(data: imageData)
                            
                            self.slideShow.setImageInputs([
                                ImageSource(image: UIImage(data: imageData)!),
                                ImageSource(image: UIImage(data: imageData)!),
                              
                            ])
                        }
                   }
                }
            }
        }
        
        // Disparo la tarea de descarga
        downloadTask.resume()
        */
        
        /*
        slideShow.setImageInputs([
            AlamofireSource(url: URL(string: myProduct?.thumbnail ?? "")!),
            AlamofireSource(url: URL(string: myProduct?.thumbnail ?? "")!),
            AlamofireSource(url: URL(string: myProduct?.thumbnail ?? "")!),
            AlamofireSource(url: URL(string: myProduct?.thumbnail ?? "")!),
            AlamofireSource(url: URL(string: myProduct?.thumbnail ?? "")!)
        ])
        */
   
       
    }
  
    

}
