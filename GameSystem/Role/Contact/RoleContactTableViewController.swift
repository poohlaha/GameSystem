//
//  RoleContactTableViewController.swift
//  GameSystem
//
//  Created by Smile on 2016/11/23.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//角色列表
class RoleContactTableViewController: BaseTableViewController {
    
    var totalList:[ContactSession] = Array<ContactSession>()
    var list:[Role] = Array<Role>()
    
    let cellHeight:CGFloat = 60
    let cellHeaderHeight:CGFloat = 20
    
    let footerHeight:CGFloat = 40
    
    var tableViewIndex:TableViewIndex?
    
    let CELL_HEIGHT:CGFloat = 70
    
    let paddingLeft:CGFloat = 15
    let leftPadding:CGFloat = 15
    let imageWidth:CGFloat = 50
    let imageHeight:CGFloat = 50
    let topOrBottomPadding:CGFloat = 10
    let bounds:CGFloat = 0
    let photoRightPadding:CGFloat = 8
    let labelHeight:CGFloat = 20
    
    var CELL_FOOTER_HEIGHT:CGFloat {
        get {
            return 0
        }
        
        set {
            self.CELL_FOOTER_HEIGHT = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadAllRolesList()
        initTableIndex()
        addHeader()
        addFooter()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //加载所有角色列表
    func loadAllRolesList(){
        self.list = RoleUtil.loadRoleList(params: nil)
        if !self.list.isEmpty && self.list.count > 0 {
            self.totalList = RoleUtil.anaylsRoleContact(roles: list)
        }
    }
    
    //MARKS: Init tableview index
    func initTableIndex(){
        let width:CGFloat = 20
        let height:CGFloat = 200
        
        self.tableViewIndex = TableViewIndex(frame: CGRect(x: tableView.frame.width - width,y: UIScreen.main.bounds.height / 2 - height,width: width,height: UIScreen.main.bounds.height),tableView: tableView!,datas: self.totalList)
        self.parent?.parent!.view.addSubview(tableViewIndex!)
    }
    
    func addHeader(){
        /*self.customSearchBar = WeChatSearchBar(frame: CGRectMake(0, 0, tableView.frame.size.width, searchHeight), placeholder: "搜索", cancelBtnText: nil, cancelBtnColor: nil,isCreateSpeakImage:true)
        self.searchLabelView = self.customSearchBar.createTextSearchLabelView(0)
        searchLabelView!.addGestureRecognizer(WeChatUITapGestureRecognizer(target:self,action: "searchLabelViewTap:"))*/
        
        tableView.frame.size = self.view.frame.size
        tableView.backgroundColor = UIColor.white
        
        let headerView:UIView = UIView()
        /*headerView.backgroundColor = self.customSearchBar.backgroundColor
        headerView.addSubview(searchLabelView!)
        headerView.layer.addSublayer(WeChatDrawView().drawLineAtLast(0,height: searchHeight))*/
        
        //添加列表
        let width:CGFloat = UIScreen.main.bounds.width
        //var height:CGFloat = searchHeight
        var height:CGFloat = 0
        let newRoleView = createOneCell(imageName: "new-friend", labelText: "添加角色", beginY: height, width: width,bounds: 0)
        height += CELL_HEIGHT
        headerView.addSubview(newRoleView)
        headerView.layer.addSublayer(BaseDrawView().drawLineAtLast(beginX: leftPadding,height: height))
        
        headerView.frame = CGRect(x:0,y:0,width:tableView.frame.size.width,height:height)
        
        tableView.tableHeaderView = headerView
        
    }
    
    //创建header上面的一个cell
    func createOneCell(imageName:String,labelText:String,beginY:CGFloat,width:CGFloat,bounds:CGFloat) -> UIView{
        let photoImageView = ComponentUtil.createPhotoView(frame: CGRect(x:paddingLeft, y:topOrBottomPadding, width:imageWidth, height:imageHeight), image: UIImage(named: imageName)!,bounds: bounds)
        
        let textLabel = ComponentUtil.createLabel(rect: CGRect(x:photoImageView.frame.origin.x + photoRightPadding + photoImageView.frame.width, y:topOrBottomPadding + (imageHeight - labelHeight) / 2 + 5, width:UIScreen.main.bounds.width - photoImageView.frame.origin.x - photoRightPadding, height:self.labelHeight), content: labelText, color: UIColor.darkText, textAlignment: .left, background: UIColor.clear, fontName: ComponentUtil.fontName, fontSize: 17)
        let view = UIView()
        view.frame = CGRect(x:0, y:beginY,width:width, height:CELL_HEIGHT)
        view.addSubview(photoImageView)
        view.addSubview(textLabel)
        view.backgroundColor = UIColor.white
        return view
    }
    
    //MARKS: Add Footer View
    func addFooter(){
        let footerView:UIView = UIView(frame: CGRect(x:0,y:0,width:tableView.frame.size.width,height:footerHeight))
        let footerlabel:UILabel = UILabel(frame: footerView.bounds)
        footerlabel.textColor = UIColor.gray
        //footerlabel.backgroundColor = UIColor.clearColor()
        footerlabel.font = UIFont.systemFont(ofSize: 16)
        footerlabel.text = "共\(self.list.count)个角色"
        footerlabel.textAlignment = .center
        
        //画底部线条
        let shape = BaseDrawView().drawLine(beginPointX: 0, beginPointY: 0, endPointX: UIScreen.main.bounds.width, endPointY: 0,color:UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1))
        shape.lineWidth = 0.2
        footerView.layer.addSublayer(shape)
        
        footerView.addSubview(footerlabel)
        footerView.backgroundColor = UIColor.white
        tableView.tableFooterView = footerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.tableViewIndex != nil {
            self.tableViewIndex?.isHidden = false
        }
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        if self.tableViewIndex != nil {
            self.tableViewIndex?.isHidden = true
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return totalList.count
    }

    //MARKS: 返回每组行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let session = self.totalList[section] as ContactSession
        return session.contacts.count
    }

    let image = ["contact1","contact2","contact3"]
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var photoName = ""
        if indexPath.row % 3 == 0 {
            photoName = image[0]
        } else if indexPath.row % 3 == 1 {
            photoName = image[1]
        } else {
            photoName = image[2]
        }
        
        let cell = RoleContactTableViewCell(style: .default, reuseIdentifier: "Cell\(indexPath.section)\(indexPath.row)",leftViewImage:UIImage(named: photoName)!,cellHeight:self.cellHeight)

        let session = self.totalList[indexPath.section]
        let contact = session.contacts[indexPath.row] as! Role
        
        //清除旧数据
        if cell.subviews.count > 0 {
            for subView in cell.subviews {
                if subView.isKind(of: UILabel.self) || subView.isKind(of: UIImageView.self){
                    subView.removeFromSuperview()
                }
            }
        }
        
        let roleNameLabel:UILabel = ComponentUtil.createLabel(rect: CGRect(x:0,y:0,width:cell.roleNameView!.frame.width,height:cell.roleNameView!.frame.height), content: "\(contact.roleName!)", color: cell.roleNameLabelColor, textAlignment: .left, background: UIColor.clear, font:cell.roleNameLabelFont!)
        cell.roleNameView?.addSubview(roleNameLabel)

        return cell
    }
    
    //MARKS: 计算行高
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.cellHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CELL_FOOTER_HEIGHT
    }

    
    //MARKS: 返回每组头标题名称
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.totalList[section].key
    }
    
    //Cell点击事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RoleContactTableViewCell//获取cell
        let image = cell.leftViewImage
        
        //根据storyboard获取controller
        let sb = UIStoryboard(name:"RoleContactDetail", bundle: nil)
        let roleDetailController = sb.instantiateViewController(withIdentifier: "RoleContactDetailTableViewController") as! RoleContactDetailTableViewController
        roleDetailController.hidesBottomBarWhenPushed = true
        prepareDetailForData(destinationController:roleDetailController,indexPath: indexPath as NSIndexPath,image:image!)
        self.navigationController?.pushViewController(roleDetailController, animated: true)
    }
    
    //MARKS :跳转到下一个页面传值(手动)
    func prepareDetailForData(destinationController:RoleContactDetailTableViewController,indexPath:NSIndexPath,image:UIImage){
        let session = self.totalList[indexPath.section]
        let contact = session.contacts[indexPath.row]  as! Role
        let roleId = contact.id
        
        destinationController.photoImage = image
        destinationController.roleId = roleId ?? 0
        //MARKS: 跳转视图后取消tableviewcell选中事件
        self.tableView.deselectRow(at: indexPath as IndexPath, animated: false)
    }
    
    //MARKS: 开启tableview编辑模式
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
