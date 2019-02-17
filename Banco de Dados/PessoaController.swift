//
//  PessoaController.swift
//  Banco de Dados
//
//  Created by Faculdade Alfa on 16/02/2019.
//  Copyright © 2019 Faculdade Alfa. All rights reserved.
//

import UIKit
import CoreData

class PessoaController {
    //nome da tabela no Model.xcdatamodeId
    private let nomeTabela = "TbPessoa"
    
    private var pessoas:[NSManagedObject] = []
    
    private var managedObject: NSManagedObjectContext!
    
    private var tabela: NSEntityDescription!
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedObject = appDelegate.managedObjectContext
        
        guard let tempTabela = NSEntityDescription.entity(forEntityName: nomeTabela, in: managedObject) else {
            return
        }
        tabela = tempTabela
        
    }
    
    func salvar(i: Int, pessoa: Pessoa) {
        if (i >= 0) {
            alterar(i: i, pessoa: pessoa)
        } else {
            inserir(pessoa: pessoa)
        }
    }

    private func inserir(pessoa: Pessoa) {
        
        let pes = NSManagedObject(entity: tabela, insertInto: managedObject)
        
        pes.setValue(pessoa.nome, forKey: "nome")
        pes.setValue(pessoa.cidade, forKey: "cidade")
        
        do {
            try managedObject.save()
        }
        catch let erro as NSError {
            print("Erro ao inserir: \(pessoa.nome). \(erro)")
        }
    }
    
    private func alterar(i: Int, pessoa: Pessoa) {
        pessoas[i].setValue(pessoa.nome, forKey: "nome")
        pessoas[i].setValue(pessoa.cidade, forKey: "cidade")
        
        do {
            try self.pessoas[i].managedObjectContext?.save()
        }
        catch let erro as NSError {
            print("Erro ao alterar: \(pessoa.nome). \(erro)")
        }
    }
    
    func deletar(i: Int) {
        do {
            managedObject.delete(pessoas[i])
            try managedObject.save()
        } catch let erro as NSError {
            print("Erro ao deletar: \(erro)")
        }
    }
    
    func buscar(filtro: NSPredicate?) -> [Pessoa] {
        pessoas = []
        var listaPessoa = [Pessoa]()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: nomeTabela)
        
        do {
            let nomeOrdem = NSSortDescriptor(key: "nome", ascending: true)
            let cidadeOrdem = NSSortDescriptor(key: "cidade", ascending: true)
            
            fetchRequest.sortDescriptors = [nomeOrdem, cidadeOrdem]
            
            if let condicao = filtro {
                fetchRequest.predicate = condicao
            }
            
            pessoas = try managedObject.fetch(fetchRequest)
        }
        catch let erro {
            print("Erro ao buscar: \(erro)")
        }
        
        for registro in pessoas {
            let nome = registro.value(forKey: "nome") as! String
            let cidade = registro.value(forKey: "cidade") as! String
            
            let pes = Pessoa(nome: nome, cidade: cidade)
            
            listaPessoa.append(pes)
        }
        
        return listaPessoa
    }
}
