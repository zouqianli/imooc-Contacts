//
//  ContactsTableViewController.m
//  Contacts
//
//  Created by 邹前立 on 2017/5/18.
//  Copyright © 2017年 zouqianli. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "MBProgressHUD+MJ.h"
#import "Person.h"
#import "AddViewController.h"
#import "EditViewController.h"
#define ContactsFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"contacts.data"] // 存储联系人的文件路径
@interface ContactsTableViewController () <AddViewControllerDelegate,EditViewControllerDelegate> {

}
@property (nonatomic,strong) NSMutableArray *contactsArray;
- (IBAction)logoutAction:(UIBarButtonItem *)sender;
- (IBAction)deleteAction:(UIBarButtonItem *)sender;
- (IBAction)addAction:(UIBarButtonItem *)sender;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self clearLines:self.tableView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (NSMutableArray *)contactsArray {
    if (!_contactsArray) {
        // 从文件读取联系人信息
        _contactsArray = [NSKeyedUnarchiver unarchiveObjectWithFile:ContactsFilePath];
        if (_contactsArray == nil) {
            _contactsArray = [NSMutableArray array];
        }
    }
    return _contactsArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsCellID" forIndexPath:indexPath];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"add2Contact"];
//    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsCellID"];
    Person *personDataForCell = [self.contactsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = personDataForCell.name;
    cell.detailTextLabel.text = personDataForCell.phoneNumber;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
// 删除一行数据
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除数据
        [self.contactsArray removeObjectAtIndex:indexPath.row];
        // 刷新tableView
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        //        [self.tableView reloadData];// 重新加载所有数据
        // 归档
        [NSKeyedArchiver archiveRootObject:self.contactsArray toFile:ContactsFilePath];
    }
}
// 去掉tableView非数据行的分割线
- (void) clearLines:(UITableView *) tableView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
}
#pragma mark - 代理接收数据
#pragma mark -- AddContactViewController delegate
- (void) addContact:(AddViewController *)addViewController didAddContact:(Person *)contact {
    // 添加数据
    [self.contactsArray addObject:contact]; // 要先初始化_contactsArray
    // 刷新tabelView
    [self.tableView reloadData];
    // 归档
    [NSKeyedArchiver archiveRootObject:self.contactsArray toFile:ContactsFilePath];
}
#pragma mark -- editContactViewController delegate
- (void)editViewController:(EditViewController *)editViewController didSaveContact:(Person *)contact {
    // 接收编辑后的数据
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    self.contactsArray[indexPath.row] = contact;
    // 刷新
    [self.tableView reloadData];
    // 归档
    [NSKeyedArchiver archiveRootObject:self.contactsArray toFile:ContactsFilePath];
}
#pragma mark - Navigation storyborad segue传递数据

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
/**
    // 因为跳转到多个页面，要进行判断
    // 获得目的控制器
    AddViewController *addVC = [segue destinationViewController];
    // 设置代理
    addVC.delegate = self;
 */
    id viewController = segue.destinationViewController; // 要跳转到的页面
    if ([viewController isKindOfClass:[AddViewController class]]) { // 跳转到添加页面
        AddViewController *addVC = viewController;
        addVC.delegate = self;
    }else if([viewController isKindOfClass:[EditViewController class]]) { // 跳转到编辑页面
        EditViewController *editVC = viewController;
        // 获取编辑（选中）的那一行indexPath
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        editVC.person = self.contactsArray[indexPath.row];// 传入要编辑的模型数据
        editVC.delegate = self;
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - button Action
- (IBAction)logoutAction:(UIBarButtonItem *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注销登录" message:@"确定要注销吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return ;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"注销" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alertController animated:YES completion:^{
        NSLog(@"不要走");
    }];
}

#pragma mark -- 第二次提交 删除按钮状态改变
- (IBAction)deleteAction:(UIBarButtonItem *)sender {
//    self.tableView.editing = YES;
    self.tableView.editing = !self.tableView.editing;
}

- (IBAction)addAction:(UIBarButtonItem *)sender {
}
@end
