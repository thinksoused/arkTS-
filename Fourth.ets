// Fourth.ets

import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';
import hilog from '@ohos.hilog';

interface Dish {
  id: number;
  name: string;
  price: number;
  desc: string;
  count: number;
}

interface FourthPageParams {
  dishes?: string;
  total?: number;
}

@Entry
@Component
struct Fourth {
  @State message: string = '支付成功！';
  @State total: number = 0;
  @State dishes: Array<Dish> = [];

  aboutToAppear() {
    const rawParams = router.getParams();
    if (rawParams == null) return;

    const params = rawParams as FourthPageParams;

    if (typeof params.dishes === 'string') {
      try {
        this.dishes = JSON.parse(params.dishes);
      } catch (e) {
        hilog.error(0x0000, 'FourthPage', 'Failed to parse dishes');
        this.dishes = [];
      }
    }

    if (typeof params.total === 'number') {
      this.total = params.total;
    }
  }

  build() {
    Column() {
      Text('✓')
        .fontSize(80)
        .fontColor('#198754')
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40 })

      Text(this.message)
        .fontSize(28)
        .fontWeight(FontWeight.Medium)
        .margin({ top: 16 })

      Text(`￥${this.total.toFixed(2)}`)
        .fontSize(36)
        .fontColor('#198754')
        .fontWeight(FontWeight.Bold)
        .margin({ top: 12 })

      Text('订单详情')
        .fontSize(18)
        .fontColor('#666')
        .margin({ top: 30, bottom: 12 })

      Column() {
        ForEach(this.dishes, (dish: Dish) => {
          if (dish.count > 0) {
            Row() {
              Text(`${dish.name} × ${dish.count}`)
                .fontColor('#333')
                .layoutWeight(1)
              Text(`￥${(dish.price * dish.count).toFixed(2)}`)
                .fontColor('#666')
            }
            .width('100%')
            .padding({ top: 8, bottom: 8 })
          }
        })
      }
      .width('80%')

      Column() {
        Button('再下一单')
          .type(ButtonType.Capsule)
          .width('80%')
          .height(50)
          .backgroundColor('#0D9FFB')
          .fontColor('#FFFFFF')
          .fontSize(18)
          .margin({ top: 40 })
          .onClick(() => {
            // 返回点餐页（Second.ets）
            router.replaceUrl({ url: 'pages/Second' });
          })

        Button('返回首页')
          .type(ButtonType.Capsule)
          .width('80%')
          .height(50)
          .backgroundColor('#F5F5F5')
          .fontColor('#333')
          .fontSize(18)
          .margin({ top: 16 })
          .onClick(() => {
            router.replaceUrl({ url: 'pages/Index' });
          })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#FFF')
  }
}