// Third.ets

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

interface ThirdPageParams {
  dishes?: string;
  total?: number;
}

@Entry
@Component
struct Third {
  @State total: number = 0;
  @State dishes: Array<Dish> = [];
  @State isProcessing: boolean = false;

  aboutToAppear() {
    const rawParams = router.getParams();
    if (rawParams == null) return;

    const params = rawParams as ThirdPageParams;

    if (typeof params.dishes === 'string') {
      try {
        this.dishes = JSON.parse(params.dishes);
      } catch (e) {
        hilog.error(0x0000, 'ThirdPage', 'Failed to parse dishes');
        this.dishes = [];
      }
    }

    if (typeof params.total === 'number') {
      this.total = params.total;
    }
  }

  build() {
    Column() {
      Text('确认订单')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40 })

      // 菜品列表
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
            .padding({ top: 10, bottom: 10 })
          }
        })
      }
      .width('80%')
      .margin({ top: 30 })
      .padding({ top: 16, bottom: 16, left: 12, right: 12 })
      .backgroundColor('#F9F9F9')
      .borderRadius(8)

      // 合计
      Row() {
        Text('合计：')
          .fontSize(18)
        Text(`￥${this.total.toFixed(2)}`)
          .fontSize(20)
          .fontColor('#FF4500')
          .fontWeight(FontWeight.Bold)
      }
      .width('80%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 20 })

      // 按钮
      Button('确认支付')
        .type(ButtonType.Capsule)
        .width('80%')
        .height(50)
        .backgroundColor('#FF4500')
        .fontColor('#FFFFFF')
        .fontSize(18)
        .margin({ top: 40 })
        .enabled(!this.isProcessing)
        .onClick(() => {
          if (this.isProcessing) return;
          this.isProcessing = true;

          // 模拟支付后跳转到支付成功页
          setTimeout(() => {
            this.isProcessing = false;
            router.pushUrl({
              url: 'pages/Fourth', // 👈 跳转到第四页
              params: {
                dishes: JSON.stringify(this.dishes),
                total: this.total
              }
            });
          }, 600);
        })

      Button('返回修改')
        .type(ButtonType.Capsule)
        .width('80%')
        .height(50)
        .backgroundColor('#F5F5F5')
        .fontColor('#333')
        .fontSize(18)
        .margin({ top: 16 })
        .onClick(() => {
          router.back(); // 回到 Second.ets
        })
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#FFF')
  }
}