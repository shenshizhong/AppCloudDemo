import { HomeButton } from '../components/HomeButton';
import { Constants } from '../common/Constants';
import { AGCAuth, AgUser } from '../services/Auth';
import { AGConnectUser } from '@hw-agconnect/auth-ohos';
import { login } from '../services/Function';
import cloud from '@hw-agconnect/cloud'
import schema from '../schema.json';
import {objectType1} from '../models/objectType1';
import {Post} from '../models/Post';

@Entry
@Component
struct Index {
  @StorageLink('user') currentUser: AgUser = new AgUser();
  @State agcUser: AGConnectUser = null;

  async aboutToAppear() {
    // 杀掉进程重启情况
    this.agcUser = await new AGCAuth(getContext(this)).getCurrentUser();
    if (this.agcUser) {
      let agcUserExtra = await this.agcUser.getUserExtra();
      this.currentUser = new AgUser(
      this.agcUser.getUid(),
      this.agcUser.getPhotoUrl(),
      this.agcUser.getPhone(),
      this.agcUser.getDisplayName(),
      agcUserExtra.getCreateTime(),
      agcUserExtra.getLastSignInTime());
      AppStorage.Set<AgUser>('user', this.currentUser);
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center }) {
      Text($r('app.string.main_page_title'))
        .width(Constants.PERCENT_100)
        .fontSize($r('app.float.main_title_font_size'))
        .textAlign(TextAlign.Center)
        .fontColor($r('app.color.body_color'))
        .margin({ bottom: Constants.LENGTH_10_PX })

      HomeButton({
        title: $r('app.string.auth_service_title'),
        description: $r('app.string.auth_service_description'),
        routeName: Constants.AUTH_ROUTE
      })

      HomeButton({
        title: $r('app.string.cloud_function_title'),
        description: $r('app.string.cloud_function_description_main'),
        routeName: Constants.FUNCTION_ROUTE
      })

      HomeButton({
        title: $r('app.string.cloudStorage_label'),
        description: $r('app.string.cloud_storage_description_main'),
        routeName: Constants.STORAGE_ROUTE
      })

      Button("获取服务器数据").onClick(()=>{
        console.log("点击了")
        this.getLoginResult();
      })


      Button("查询数据库").onClick(async ()=>{
        console.log("查询数据")
        const resultArray = await cloud.database({objectTypeInfo: schema, zoneName: "cloudDBZone1"}).collection(objectType1).query().get();
        console.log("更新成功：" +  JSON.stringify(resultArray))
      })

      Button("增加一条数据").onClick(async ()=>{
        console.log("连接数据库")
        try {
          let object = new objectType1();
          object.bookName = 'ssz新增书'
          object.author = 'ssz'
          const record = await cloud.database({objectTypeInfo: schema, zoneName: "cloudDBZone1"}).collection(objectType1).upsert(object);
          console.log("增加成功：" + record)
        }catch (err){
          console.log("增加失败")
        }
      })

      Button("删除数据").onClick(async ()=>{
        console.log("连接数据库")
        try {
          let object = new objectType1();
          object.bookName = 'ssz新增书'
          const record = await cloud.database({objectTypeInfo: schema, zoneName: "cloudDBZone1"}).collection(objectType1).delete(object);
          console.log("删除成功：" + record)
        }catch (err){
          console.log("删除失败")
        }
      })

    }
    .height(Constants.PERCENT_100)
    .width(Constants.PERCENT_100)
    .padding(Constants.LENGTH_10_PX)
    .backgroundColor($r('app.color.start_window_background'))
  }
  getLoginResult = () => {
    login(getContext(this)).then((data) => {
      let message: Message =  JSON.parse(data) as Message  //这里是数据格式的转换，转成对象。
      console.log('获取的数据：', message.desc);
    }).catch((err) => {
      console.error('error: ', err && err.message);
    });
  }
}

class Message{
  public  code: string
  public  desc: string
}