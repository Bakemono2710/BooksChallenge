//
//  mainProductsCollectionnViewController.swift
//  Merli
//
//  Created by Jésica González Baqué on 04/06/2021.
//

import UIKit
 
private let reuseIdentifier = "productCollectionViewCell"


// Variable global que refrencia a TODOS los libros que se descargaron
var booksAll = [Book]()

// Variable global que refrencia a los libros que se filtrqdos por título / ordenados
var booksFiltered = [Book]()


class mainProductsCollectionnViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
          super.viewDidLoad()
        
        if self.traitCollection.userInterfaceStyle == .dark {
            overrideUserInterfaceStyle = .dark
        } else{
            overrideUserInterfaceStyle = .light
        }
        
        // Grabo la búsqueda en UserDefaults.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        searchTextField.text = appDelegate?.getLastSearch()
      }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func filterAction(_ sender: UISegmentedControl) {
        if( sender.selectedSegmentIndex == 0 ) {
            booksFiltered = booksAll
        }
        else if( sender.selectedSegmentIndex == 1 ) {
            booksFiltered = filterBooksByAvailable(booksAll, isAvailable: true)
        }
        else {
            booksFiltered = filterBooksByAvailable(booksAll, isAvailable: false)
        }
        
        productsCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    @IBAction func btnMenu(_ sender: UIButton) {
        //showAlertNotImplementd()
        /*
        booksFiltered = filterBooksByAvailable(booksAll, isAvailable: true)
        productsCollectionView.reloadData()
         */
        orderBooks(ascendente:true)
    }
    
    @IBAction func btnShoppingCart(_ sender: Any) {
        //showAlertNotImplementd()
        /*
        booksFiltered = filterBooksByAvailable(booksAll, isAvailable: false)
        productsCollectionView.reloadData()
         */
        orderBooks(ascendente:false)
    }
    
    func showAlertNotImplementd()
    {
        let alert = UIAlertController(title: "Flux IT", message:"Opción no implementada.", preferredStyle:.alert)
        alert.addAction(UIAlertAction(title:"OK", style:.default, handler: {_ in print("PRESS!")} ))
        self.present(alert, animated: true, completion: nil)
    }
    
    func searchProducts(_ text:String)
    {
        // Grabo la búsqueda en UserDefaults.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.setUserDefaults(text)
        
        // Traigo JSON (*)
        let encodedText:String = text.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
    
        print("BUSCANDO....", encodedText)
        
        let urlString =
            "https://qodyhvpf8b.execute-api.us-east-1.amazonaws.com/test/books"
      
        // Descarga del JSON con los libros.
        if let url = URL( string: urlString ) {
            if let data = try? Data(contentsOf: url) {
                // Todo OK
                print("TODO OK")
                parse(json: data ,searchText:text)
            }
            else {
              print("Error en la descarga.")
            }
        }
      //(*)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchProducts(textField.text!)
        
        self.view.endEditing(true)
        
        return true
    }
      
    func parse(json:Data, searchText texto:String) {

        //print(String(data:json, encoding:String.Encoding.utf8)! as String)
        
        let decoder = JSONDecoder()
        if let jsonData = try? decoder.decode([Book].self, from: json) {
            
            var booksJSON = [Book]()
            
            // Traigo TODOS los libros
            booksJSON = jsonData
               
            // Filtro según el campo de búsqueda
            booksAll = filterBooksByName(texto, booksJSON)
            booksFiltered = booksAll
            
            // Recargo la colectionView
            productsCollectionView.reloadData()
        }
    }
    
    func orderBooks(ascendente ascendente:Bool)
    {
        
        if( ascendente ) {
            booksFiltered = booksFiltered.sorted(by: {$0.popularidad > $1.popularidad})
        }
        else {
            booksFiltered = booksFiltered.sorted(by: {$0.popularidad < $1.popularidad})
        }
        
        // Recargo la colectionView
        productsCollectionView.reloadData()
    }
    
    func filterBooksByName(_ name:String, _ books:[Book])->[Book]
    {
        return  books.filter{$0.nombre.contains(name)}
    }
    
    func filterBooksByAvailable(_ books:[Book] ,isAvailable available:Bool)->[Book]
    {
        var dev = [Book]()
        for elem in books {
            if( elem.disponibilidad == available ){
                dev.append(elem)
            }
        }
        
        return  dev
    }

      /*
      // MARK: - Navigation

      // In a storyboard-based application, you will often want to do a little preparation before navigation
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          // Get the new view controller using [segue destinationViewController].
          // Pass the selected object to the new view controller.
      }
      */

      // MARK: UICollectionViewDataSource

      // Devuelve la cantidad de secciones de la CV
      func numberOfSections(in collectionView: UICollectionView) -> Int {
          // #warning Incomplete implementation, return the number of sections
          return 1
      }


      // Devuelve la cantidad de elementos del CV
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          // #warning Incomplete implementation, return the number of items
          return booksFiltered.count
      }
      
      /*
          1) Aparece la pantalla sin elementos
          2) Se realiza una búsqueda
              3) Descargar un JSON con el resultado
              4) Recargar la CV
     
     collectionview prototype cell
     celdas prototipada
     collectionview prototype cell
     celdas prototipada
     
     iOS swift collection load images asynchronically
       
       */

      // Cada vez que el SO tiene que obtener una celda se invoca a este método.
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
            // Devuelve una celda reutilizada
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCollectionViewCell", for: indexPath) as! productCollectionViewCell

            // Obtenemos el registro en cuestión.
            let registro = booksFiltered[indexPath.row]
        
            // Configuro la celda. Ojo que tengo que asegurarme de limpiarla.
            cell.backgroundColor = .lightGray
            cell.titleLabel.text = registro.nombre
        cell.autorLabel.text = registro.autor
            cell.productImage.image  = nil //UIImage(named: "placeholder-image")
        
        cell.Popularidad.text = String( registro.popularidad)
        
        cell.Estado.text = registro.disponibilidad ? "Disponible":"No disponible"
        
            cell.layer.cornerRadius = 5
            cell.clipsToBounds = true
        
            // Muestro y arranco el activity.
            cell.activity.isHidden = false
            cell.activity.startAnimating()
        
            // Descargo la imagen.
            guard let picURL = URL(string: registro.imagen) else { return cell }
            let session = URLSession(configuration: .default)
            let downloadTask = session.dataTask(with: picURL ) { (data, response, error) in
                if let e = error {
                    print("Error" + e.localizedDescription)
                } else {
                   // print("Descargada ok!")
                    if let res = response as? HTTPURLResponse {
                        if let imageData = data {
                           // print("Creada imagen ok!")
                            // Espera.
                            /*
                            do {
                                sleep(3)
                            }
                            */
                            // Ejecuto en el main thread la asignación de la imagen, detener y ocultar el reloj.
                            DispatchQueue.main.async {
                                cell.activity.stopAnimating()
                                cell.activity.isHidden = true
                                cell.productImage.image =  UIImage(data: imageData)
                            }
                       }
                    }
                }
                
            }
        
            // Disparo la tarea de descarga
            downloadTask.resume()
        
            // Devuelvo la celda.
            return cell
      }

      // MARK: UICollectionViewDelegate

      
      // Uncomment this method to specify if the specified item should be selected
      func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
          

          
        // Instancio nueva pantalla de detalle.
        let detailVC = storyboard!.instantiateViewController(identifier: "detailVC") as! detailViewController
    
        // Inyección de dependencia.
        // Obtenemos el registro en cuestión.
        let registro = booksFiltered[indexPath.row]
        detailVC.myProduct = registro
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        /*
          let storyBoard : UIStoryboard  = UIStoryboard(name: "Main", bundle: nil)
          
          let detailViewController = storyBoard.instantiateViewController(identifier: "detailViewController")
          
          self.present(detailViewController, animated:true, completion: nil)
          */
          return true
      }
  }


  private let itemsPerRow : CGFloat = 2
  private let sectionInsets = UIEdgeInsets (
      top:  50.0,
      left: 20.0,
      bottom: 50.0,
      right: 20.0 )

  extension mainProductsCollectionnViewController: UICollectionViewDelegateFlowLayout {
      
      func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout,
                           sizeForItemAt indexPath: IndexPath
      ) -> CGSize {
          let paddingSpace = sectionInsets.left * (itemsPerRow+1)
          let availableWidth = view.frame.width - paddingSpace
          let widthPerItem = availableWidth / itemsPerRow
          
          /*
          if indexPath.row % 2 == 1 {
              return CGSize(width: widthPerItem, height: widthPerItem - 20)
          }
          else
          {*/
              return CGSize(width: widthPerItem, height: widthPerItem + 20)
         // }
      }
      
      func collectionView(
          _ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, insetForSectionAt section: Int ) -> UIEdgeInsets {
          return sectionInsets
          }
      
      
      func collectionView(
          _ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout,
          minimumLineSpacingForSectionAt section: Int ) -> CGFloat {
          return sectionInsets.left
      }

}
