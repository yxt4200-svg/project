<template>
  <div :key="vueRest"
       class="addBrand-container">
    <div :key="restKey"
         class="container">
      <el-form ref="ruleForm"
               :model="ruleForm"
               :rules="rules"
               :inline="true"
               label-width="180px"
               class="demo-ruleForm">
        <div>
          <el-form-item label="套餐名称:"
                        prop="name">
            <el-input v-model="ruleForm.name"
                      placeholder="请填写套餐名称"
                      maxlength="14" />
          </el-form-item>
          <el-form-item label="套餐分类:"
                        prop="idType">
            <el-select v-model="ruleForm.idType"
                       placeholder="请选择套餐分类"
                       @change="$forceUpdate()">
              <el-option v-for="(item, index) in setMealList"
                         :key="index"
                         :label="item.name"
                         :value="item.id" />
            </el-select>
          </el-form-item>
        </div>
        <div>
          <el-form-item label="套餐价格:"
                        prop="price">
            <el-input v-model="ruleForm.price"
                      placeholder="请设置套餐价格" />
          </el-form-item>
        </div>
        <div>
          <el-form-item label="套餐菜品:"
                        required>
            <el-form-item>
              <div class="addDish">
                <span v-if="dishTable.length == 0"
                      class="addBut"
                      @click="openAddDish('new')">
                  + 添加菜品</span>
                <div v-if="dishTable.length != 0"
                     class="content">
                  <div class="addBut"
                       style="margin-bottom: 20px"
                       @click="openAddDish('change')">
                    + 添加菜品
                  </div>
                  <div class="table">
                    <el-table :data="dishTable"
                              style="width: 100%">
                      <el-table-column prop="name"
                                       label="名称"
                                       width="180"
                                       align="center" />
                      <el-table-column prop="price"
                                       label="原价"
                                       width="180"
                                       align="center">
                        <template slot-scope="scope">
                          {{ (Number(scope.row.price).toFixed(2) * 100) / 100 }}
                        </template>
                      </el-table-column>
                      <el-table-column prop="address"
                                       label="份数"
                                       align="center">
                        <template slot-scope="scope">
                          <el-input-number v-model="scope.row.copies"
                                           size="small"
                                           :min="1"
                                           :max="99"
                                           label="描述文字" />
                        </template>
                      </el-table-column>
                      <el-table-column prop="address"
                                       label="操作"
                                       width="180px;"
                                       align="center">
                        <template slot-scope="scope">
                          <el-button type="text"
                                     size="small"
                                     class="delBut non"
                                     @click="delDishHandle(scope.$index)">
                            删除
                          </el-button>
                        </template>
                      </el-table-column>
                    </el-table>
                  </div>
                </div>
              </div>
            </el-form-item>
          </el-form-item>
        </div>
        <div>
          <el-form-item label="套餐图片:"
                        required
                        prop="image">
            <image-upload :prop-image-url="imageUrl"
                          @imageChange="imageChange">
              图片大小不超过2M<br>仅能上传 PNG JPEG JPG类型图片<br>建议上传200*200或300*300尺寸的图片
            </image-upload>
          </el-form-item>
        </div>
        <div class="address">
          <el-form-item label="套餐描述:">
            <el-input v-model="ruleForm.description"
                      type="textarea"
                      :rows="3"
                      maxlength="200"
                      placeholder="套餐描述，最长200字" />
          </el-form-item>
        </div>
        <div class="subBox address">
          <el-form-item>
            <el-button @click="() => $router.back()">
              取消
            </el-button>
            <!-- 主保存按钮保持原有 primary（局部样式会覆盖） -->
            <el-button type="primary"
                       :class="{ continue: actionType === 'add' }"
                       @click="submitForm('ruleForm', false)">
              保存
            </el-button>
            <!-- 保存并继续添加：改为订单页样式（蓝色渐变） -->
            <el-button v-if="actionType == 'add'"
                       type="primary"
                       class="continue-add"
                       @click="submitForm('ruleForm', true)">
              保存并继续添加
            </el-button>
          </el-form-item>
        </div>
      </el-form>
    </div>

    <!-- 添加菜品弹窗等保持不变 -->
    <el-dialog v-if="innerDialogVisible"
               title="添加菜品"
               class="addDishList"
               :visible.sync="innerDialogVisible"
               width="60%"
               :before-close="handleInnerClose">
      <el-input v-model="value"
                class="seachDish"
                placeholder="请输入菜品名称进行搜索"
                style="width: 293px; height: 40px"
                size="small"
                clearable>
        <i slot="prefix"
           class="el-input__icon el-icon-search"
           style="cursor: pointer"
           @click="seachHandle" />
      </el-input>
      <AddDish v-if="innerDialogVisible"
               ref="adddish"
               :check-list="checkList"
               :seach-key="seachKey"
               :dish-list="dishList"
               @checkList="getCheckList" />
      <span slot="footer"
            class="dialog-footer">
        <el-button @click="handleInnerClose">取 消</el-button>
        <el-button type="primary"
                   @click="addTableList">添 加</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import ImageUpload from '@/components/ImgUpload/index.vue'
import AddDish from './components/AddDish.vue'
import { querySetmealById, addSetmeal, editSetmeal } from '@/api/setMeal'
import { getCategoryList } from '@/api/dish'

@Component({
  name: 'addSetmeal',
  components: {
    AddDish,
    ImageUpload
  }
})
export default class extends Vue {
  private restKey: number = 0
  private vueRest: number = 1
  private value: string = ''
  private setMealList: [] = []
  private seachKey: string = ''
  private dishList: [] = []
  private imageUrl: string = ''
  private actionType: string = ''
  private dishTable: [] = []
  private innerDialogVisible: boolean = false
  private checkList: any[] = []
  private ruleForm = {
    name: '',
    categoryId: '',
    price: '',
    code: '',
    image: '',
    description: '',
    dishList: [],
    status: true,
    idType: '',
    id: ''
  }

  get rules() {
    return {
      name: {
        required: true,
        validator: (rule: any, value: string, callback: Function) => {
          if (!value) {
            callback(new Error('请输入套餐名称'))
          } else {
            const reg = /^([A-Za-z0-9\u4e00-\u9fa5]){2,20}$/
            if (!reg.test(value)) {
              callback(new Error('套餐名称输入不符，请输入2-20个字符'))
            } else {
              callback()
            }
          }
        },
        trigger: 'blur'
      },
      idType: {
        required: true,
        message: '请选择套餐分类',
        trigger: 'change'
      },
      image: {
        required: true,
        message: '菜品图片不能为空'
      },
      price: {
        required: true,
        validator: (rules: any, value: string, callback: Function) => {
          const reg = /^([1-9]\d{0,5}|0)(\.\d{1,2})?$/
          if (!reg.test(value) || Number(value) <= 0) {
            callback(
              new Error(
                '套餐价格格式有误，请输入大于零且最多保留两位小数的金额'
              )
            )
          } else {
            callback()
          }
        },
        trigger: 'blur'
      }
    }
  }

  created() {
    this.getDishTypeList()
    this.actionType = this.$route.query.id ? 'edit' : 'add'
    if (this.$route.query.id) {
      this.init()
    }
  }

  private resetForm() {
    this.ruleForm = {
      name: '',
      categoryId: '',
      price: '',
      code: '',
      image: '',
      description: '',
      dishList: [],
      status: true,
      idType: '',
      id: ''
    }
    this.dishTable = []
    this.checkList = []
    this.imageUrl = ''
  }

  private async init() {
    querySetmealById(this.$route.query.id).then(res => {
      if (res && res.data && res.data.code === 1) {
        this.ruleForm = res.data.data
        this.ruleForm.status = res.data.data.status == '1'
        this.ruleForm.price = String(res.data.data.price)
        this.imageUrl = res.data.data.image
        this.checkList = res.data.data.setmealDishes
        this.dishTable = res.data.data.setmealDishes.reverse()
        this.ruleForm.idType = res.data.data.categoryId
      } else {
        this.$message.error(res.data.msg)
      }
    })
  }

  private seachHandle() {
    this.seachKey = this.value
  }

  private getDishTypeList() {
    getCategoryList({ type: 2, page: 1, pageSize: 1000 }).then(res => {
      if (res && res.data && res.data.code === 1) {
        this.setMealList = res.data.data.map((obj: any) => ({
          ...obj,
          idType: obj.id
        }))
      } else {
        this.$message.error(res.data.msg)
      }
    })
  }

  private delDishHandle(index: any) {
    this.dishTable.splice(index, 1)
    this.checkList = this.dishTable
  }

  private getCheckList(value: any) {
    this.checkList = [...value].reverse()
  }

  private openAddDish(st: string) {
    this.seachKey = ''
    this.innerDialogVisible = true
  }

  private handleInnerClose() {
    this.innerDialogVisible = false
    this.checkList = JSON.parse(JSON.stringify(this.dishTable))
  }

  private addTableList() {
    this.dishTable = JSON.parse(JSON.stringify(this.checkList))
    this.dishTable.forEach((n: any) => {
      n.copies = 1
    })
    this.innerDialogVisible = false
  }

  public submitForm(formName: any, st: any) {
    ;(this.$refs[formName] as any).validate((valid: any) => {
      if (valid) {
        if (this.dishTable.length === 0) {
          return this.$message.error('套餐下菜品不能为空')
        }
        if (!this.ruleForm.image) return this.$message.error('套餐图片不能为空')

        let prams = { ...this.ruleForm } as any
        prams.setmealDishes = this.dishTable.map((obj: any) => ({
          copies: obj.copies,
          dishId: obj.dishId,
          name: obj.name,
          price: obj.price
        }))
        prams.status = this.actionType === 'add' ? 0 : this.ruleForm.status ? 1 : 0
        prams.categoryId = this.ruleForm.idType

        if (this.actionType == 'add') {
          delete prams.id
          addSetmeal(prams)
            .then(res => {
              if (res && res.data && res.data.code === 1) {
                this.$message.success('套餐添加成功！')
                if (!st) {
                  this.$router.push({ path: '/setmeal' })
                } else {
                  this.restKey++
                  this.resetForm()
                }
              } else {
                this.$message.error(res.data.msg)
              }
            })
            .catch(err => {
              this.$message.error('请求出错了：' + err.message)
            })
        } else {
          delete prams.updateTime
          delete prams.createTime
          editSetmeal(prams)
            .then(res => {
              if (res && res.data && res.data.code === 1) {
                this.$message.success('套餐修改成功！')
                this.$router.push({ path: '/setmeal' })
              } else {
                this.$message.error(res.data.msg)
              }
            })
            .catch(err => {
              this.$message.error('请求出错了：' + err.message)
            })
        }
      }
    })
  }

  imageChange(value: any) {
    this.ruleForm.image = value
  }
}
</script>

<style lang="scss">
/* 保留原有样式（不修改） */
.avatar-uploader .el-icon-plus:after {
  position: absolute;
  display: inline-block;
  content: ' ' !important;
  left: calc(50% - 20px);
  top: calc(50% - 40px);
  width: 40px;
  height: 40px;
  background: url('./../../assets/icons/icon_upload@2x.png') center center
    no-repeat;
  background-size: 20px;
}
</style>

<style lang="scss">
.addBrand-container {
  /* ...existing styles... */

  .subBox {
    padding-top: 30px;
    text-align: center;
    border-top: solid 1px #ebeef5;

    /* 覆盖 primary 按钮（与订单页一致的蓝色渐变） */
    .el-button--primary {
      background: linear-gradient(135deg, #4FACFE 0%, #00F2FE 100%);
      border: none;
      color: #fff;
      box-shadow: 0 6px 16px rgba(79,172,254,0.12);
      transition: all 0.18s;
    }
    .el-button--primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 10px 22px rgba(79,172,254,0.18);
    }

    /* 针对“保存并继续添加”额外类（若需要单独样式） */
    .continue-add {
      padding: 8px 16px;
      border-radius: 6px;
    }
  }

  /* 新增：确保模板中的 “+ 添加菜品” 使用和订单页一致的蓝色主按钮样式 */
  .addDish {
    .addBut {
      display: inline-block;
      padding: 0 20px;
      border-radius: 8px;
      line-height: 40px;
      cursor: pointer;
      color: #fff;
      font-weight: 600;
      background: linear-gradient(135deg, #4FACFE 0%, #00F2FE 100%);
      box-shadow: 0 6px 16px rgba(79,172,254,0.12);
      transition: all 0.18s;
    }
    .addBut:hover {
      transform: translateY(-2px);
      box-shadow: 0 10px 22px rgba(79,172,254,0.18);
    }
  }
  
  /* ...existing styles... */
}
</style>

<style lang="scss" scoped>
.addBrand-container {
  margin: 30px;

  .container {
    position: relative;
    z-index: 1;
    background: #fff;
    padding: 30px;
    border-radius: 4px;
    min-height: 500px;

    .subBox {
      padding-top: 30px;
      text-align: center;
      border-top: solid 1px #ebeef5;
    }
  }
}
</style>