// DishDetail.ets

import { router } from '@kit.ArkUI';
import hilog from '@ohos.hilog';

interface Dish {
  id: number;
  name: string;
  price: number;
  desc: string;
  count: number;
  materials?: string; // 使用材料
  origin?: string;    // 来源地
}

interface DishDetailParams {
  dish?: string;
}

@Entry
@Component
struct DishDetail {
  @State dish: Dish = {
    id: 0,
    name: '',
    price: 0,
    desc: '',
    count: 0,
    materials: '',
    origin: ''
  };

  aboutToAppear() {
    const rawParams = router.getParams();
    if (rawParams == null) return;

    const params = rawParams as DishDetailParams;

    if (typeof params.dish === 'string') {
      try {
        this.dish = JSON.parse(params.dish);
      } catch (e) {
        hilog.error(0x0000, 'DishDetail', 'Failed to parse dish');
      }
    }
  }

  build() {
    Column() {
      Text(this.dish.name)
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40 })

      Text('价格')
        .fontSize(18)
        .fontColor('#666')
        .margin({ top: 16 })
      Text(`￥${this.dish.price.toFixed(2)}`)
        .fontSize(24)
        .fontColor('#FF4500')

      Text('描述')
        .fontSize(18)
        .fontColor('#666')
        .margin({ top: 20 })
      Text(this.dish.desc)
        .fontSize(16)
        .fontColor('#333')

      Text('使用材料')
        .fontSize(18)
        .fontColor('#666')
        .margin({ top: 20 })
      Text(this.dish.materials || '未提供材料信息')
        .fontSize(16)
        .fontColor('#333')

      Text('来源地')
        .fontSize(18)
        .fontColor('#666')
        .margin({ top: 20 })
      Text(this.dish.origin || '未提供来源地信息')
        .fontSize(16)
        .fontColor('#333')

      Button('返回')
        .type(ButtonType.Capsule)
        .width('80%')
        .height(50)
        .backgroundColor('#F5F5F5')
        .fontColor('#333')
        .fontSize(18)
        .margin({ top: 40 })
        .onClick(() => {
          router.back(); // 返回上一页
        })
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#FFF')
  }
}