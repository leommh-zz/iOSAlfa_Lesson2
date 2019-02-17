//
//  ViewController.swift
//  Banco de Dados
//
//  Created by Faculdade Alfa on 16/02/2019.
//  Copyright © 2019 Faculdade Alfa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet var campoNome: UITextField!
    @IBOutlet var campoCidade: UITextField!
    @IBOutlet var tabela: UITableView!
    @IBOutlet var campoBusca: UISearchBar!
    
    var listaPessoa = [Pessoa]()
    var tbPessoa = PessoaController()
    var itemSelecionado = -1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        carregarDados()
    }
    
    func limparDados() {
        campoNome.text = ""
        campoCidade.text = ""
        itemSelecionado = -1
    }
    
    func carregarDados() {
        var filtro: NSPredicate? = nil
        let textoBusca = campoBusca.text ?? ""
        if (textoBusca != "") {
            filtro = NSPredicate(format: "cidade contains[c] %@ OR nome contains[c] %@", textoBusca, textoBusca)
        }
        
        listaPessoa = tbPessoa.buscar(filtro: filtro)
        tabela.reloadData()
        limparDados()
    }
    
    @IBAction func cancelar() {
        campoBusca.text = ""
        limparDados()
        carregarDados()
    }
    
    @IBAction func salvar() {
        let pes = Pessoa(nome: campoNome.text ?? "", cidade: campoCidade.text ?? "")
        tbPessoa.salvar(i: itemSelecionado, pessoa: pes)
        carregarDados()
    }
    
    @IBAction func excluir() {
        if(itemSelecionado >= 0) {
            tbPessoa.deletar(i: itemSelecionado)
            carregarDados()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaPessoa.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pes = listaPessoa[indexPath.row]
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula")!
        celula.textLabel?.text = pes.nome
        celula.detailTextLabel?.text = pes.cidade
        return celula
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pes = listaPessoa[indexPath.row]
        campoNome.text = pes.nome
        campoCidade.text = pes.cidade
        itemSelecionado = indexPath.row
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        carregarDados()
    }
    
}

