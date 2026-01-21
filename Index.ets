// Index.ets
import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = '餐厅点餐系统';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(24)
          .fontColor('#333')
          .margin({ bottom: 30 })

        Button('开始点餐')
          .type(ButtonType.Capsule)
          .width(200)
          .height(45)
          .fontSize(16)
          .backgroundColor('#FF4500')
          .onClick(() => this.navigateToSecondPage())
      }
      .width('100%')
    }
    .height('100%')
    .padding(20)
    .justifyContent(FlexAlign.Center)
  }

  private navigateToSecondPage() {
    router.pushUrl({ url: 'pages/Second' })
      .then(() => {
        console.info('页面跳转成功');
      })
      .catch((err: BusinessError) => {
        console.error(`跳转失败 Code: ${err.code}, Message: ${err.message}`);
      });
  }
}