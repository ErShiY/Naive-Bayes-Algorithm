# Classification of Benign and Malignant Breast Cancer Based on Naive Bayes Algorithm
## 基于朴素贝叶斯算法实现对乳腺癌良恶性的分类
  ### 该算法基于matlab,以及机器学习，准确率没有以往论文的高，仅提供一个思路

此算法在利用朴素贝叶斯算法实现垃圾邮件的分类上进行了延申，将原有的连续的标称型数据模型的基础上，
通过超参数，将数值型的数据转化为另一种标称型数据，再放入贝叶斯模型中进行分类测试。
证明朴素贝叶斯对数值型的数据的分类上也有一定的表现。

## 数据集采用的是WDBC公开数据集
### WDBC数据集 含有569个样本，其中212个为恶性乳腺肿瘤，357个为良性乳腺肿瘤，每个样本含有32个特征
  具体特征含义可见数据集中.names文件。
  代码仅实现了其中的两组特征所获得的准确率。
  可达到94.2%和90.6%的准确率。
![image](https://github.com/ErShiY/Naive-Bayes-Algorithm/assets/76460723/cf43aab1-8fd8-4feb-b6db-64e61c01a253)
![image](https://github.com/ErShiY/Naive-Bayes-Algorithm/assets/76460723/61131e28-597f-47ef-a78c-213cf2451154)

注：该算法是在《机器学习基础——原理、算法与实践》袁梅宇所著，基础上进行代码的改写。
如果对机器学习感兴趣的话，推荐阅读此书。


此算法仅供参考学习，如有疑问可与作者联系
1074734511@qq.com

