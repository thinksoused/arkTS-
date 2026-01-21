// Second.ets

import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';
import hilog from '@ohos.hilog';

interface Dish {
  id: number;
  name: string;
  price: number;
  desc: string;
  count: number;
  materials?: string; // 新增字段：使用材料
  origin?: string; // 新增字段：来源地
}

interface RouterParams {
  dishes?: string;
}

interface OrderNavigateParams {
  dishes: string;
  total: number;
}

@Entry
@Component
struct SecondPage {
  @State dishes: Array<Dish> = [];
  @State isProcessing: boolean = false;
  @State totalPrice: string = "0.00"; // 👈 新增状态变量

  // 删除了原来的 get totalPrice() 方法

  aboutToAppear() {
    const rawParams = router.getParams();
    let dishesParamValue: string | null = null;

    if (rawParams != null) {
      const params = rawParams as RouterParams;
      if (typeof params.dishes === 'string') {
        dishesParamValue = params.dishes;
      }
    }

    const defaultDishes: Dish[] = [
      {
        id: 1001,
        name: '宫保鸡丁',
        price: 42,
        desc: '传统川菜，鸡丁鲜嫩配合花生米的香脆',
        count: 0
      },
      {
        id: 2003,
        name: '清炒时蔬',
        price: 28,
        desc: '时令蔬菜清炒，保留食材原味',
        count: 0
      }
    ];

    if (dishesParamValue !== null) {
      try {
        this.dishes = JSON.parse(dishesParamValue);
        hilog.info(0x0000, 'SecondPage', 'Dishes initialized from params');
      } catch (error) {
        hilog.error(0x0000, 'SecondPage', `Parse error: ${(error as Error).message}`);
        this.dishes = defaultDishes;
      }
    } else {
      this.dishes = defaultDishes;
    }

    // 👇 初始化总价
    this.calculateTotalPrice();
  }

  // 👇 新增：计算总价并更新状态
  private calculateTotalPrice() {
    let total = 0;
    for (let i = 0; i < this.dishes.length; i++) {
      const d = this.dishes[i];
      const price = Number(d.price);
      const count = Number(d.count);
      if (!isNaN(price) && !isNaN(count) && count > 0) {
        total += price * count;
      }
    }
    this.totalPrice = total.toFixed(2);
  }

  build() {
    Column() {
      List({ space: 12 }) {
        ForEach(this.dishes, (item: Dish) => {
          ListItem() {
            this.buildDishItem(item)
          }
          .id(item.id.toString())
        })
      }
      .layoutWeight(1)
      .divider({ strokeWidth: 1, color: '#eee' })

      this.buildOrderFooter()
    }
    .padding(12)
    .backgroundColor('#F5F5F5')
  }

  @Builder
  private buildDishItem(item: Dish) {
    Row() {
      // 👈 左侧：可点击跳转详情
      Column() {
        Text(item.name)
          .fontSize(18)
          .fontColor('#333')
        Text(item.desc)
          .fontSize(12)
          .fontColor('#666')
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .onClick(() => {
        // ✅ 仅左侧区域点击跳转详情
        router.pushUrl({
          url: 'pages/DishDetail',
          params: {
            dish: JSON.stringify(item)
          }
        });
      })

      // 右侧：数量控制（不干扰跳转）
      Row() {
        Text('-')
          .fontSize(24)
          .fontColor('#666')
          .onClick(() => {
            this.updateCount(item.id, -1);
          })

        Text(item.count.toString())
          .width(40)
          .textAlign(TextAlign.Center)
          .fontSize(16)
        Text('+')
          .fontSize(24)
          .fontColor('#666')
          .onClick(() => {
            this.updateCount(item.id, 1);
          })
      }
      .padding(8)
      .borderRadius(20)
      .backgroundColor('#FFF')
    }
    .padding(12)
    .backgroundColor('#FFF')
    .borderRadius(8)
  }

  @Builder
  private buildOrderFooter() {
    Column() {
      Row() {
        Text('合计：')
          .fontSize(16)
        // 👇 直接使用 @State 变量
        Text(`￥${this.totalPrice}`)
          .fontSize(18)
          .fontColor('#FF4500')
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ bottom: 12 })

      Button('提交订单')
        .type(ButtonType.Capsule)
        .width('100%')
        .height(40)
        .backgroundColor('#FF4500')
        .onClick(() => this.submitOrder())
        .enabled(!this.isProcessing)
    }
    .padding(12)
    .backgroundColor('#FFF')
    .borderRadius(8)
    .shadow({
      radius: 4,
      color: '#10000000',
      offsetX: 0,
      offsetY: 2
    })
  }

  private updateCount(id: number, delta: number) {
    const newDishes = this.dishes.map(item => {
      if (item.id === id) {
        const newCount = Math.max(0, Number(item.count) + delta);
        return {
          id: item.id,
          name: item.name,
          price: item.price,
          desc: item.desc,
          count: newCount
        } as Dish;
      }
      return {
        id: item.id,
        name: item.name,
        price: item.price,
        desc: item.desc,
        count: item.count
      } as Dish;
    });

    this.dishes = newDishes;
    this.calculateTotalPrice(); // 👈 关键：更新总价
    hilog.info(0x0000, 'SecondPage', `Updated dish ${id}, new dishes: ${JSON.stringify(newDishes)}`);
  }

  private async submitOrder() {
    if (this.isProcessing) {
      return;
    }
    this.isProcessing = true;

    try {
      const selected = this.dishes.filter(dish => dish.count > 0);
      if (selected.length === 0) {
        throw new Error('未选择任何菜品');
      }

      const params: OrderNavigateParams = {
        dishes: JSON.stringify(selected),
        total: parseFloat(this.totalPrice) // 👈 现在是字符串，可正常解析
      };

      await router.pushUrl({
        url: 'pages/Third',
        params: params
      });
    } catch (err) {
      const message = (err as Error).message || '未知错误';
      hilog.error(0x0000, 'SecondPage', `提交失败: ${message}`);
    } finally {
      this.isProcessing = false;
    }
  }
}