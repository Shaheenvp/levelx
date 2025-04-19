import 'package:get/get.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';

class PostController extends GetxController {
  final ApiService _apiService = ApiService();
  RxList<Post> posts = <Post>[].obs;
  RxBool isLoading = true.obs;
  RxString selectedCategory = "Trending".obs;

  @override
  void onInit() {
    fetchPosts();
    super.onInit();
  }

  Future<void> fetchPosts() async {
    try {
      isLoading(true);
      final List<Post> fetchedPosts = await _apiService.fetchPosts();
      posts.value = fetchedPosts;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load posts: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
  }
}
