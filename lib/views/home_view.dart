import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/post_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.put(PostController());

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Social Media Posts',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.notifications_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150?img=${DateTime.now().millisecond % 70}'),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildCategorySelector(postController),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (postController.isLoading.value) {
                return const Center(child: CupertinoActivityIndicator());
              } else {
                return RefreshIndicator(
                  onRefresh: postController.fetchPosts,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: postController.posts.length,
                    itemBuilder: (context, index) {
                      final post = postController.posts[index];
                      return _buildPostCard(post, index);
                    },
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(PostController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildCategoryButton('Trending', controller),
          const SizedBox(width: 10),
          _buildCategoryButton('Relationship', controller),
          const SizedBox(width: 10),
          _buildCategoryButton('Self Care', controller),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category, PostController controller) {
    return Obx(() {
      final isSelected = controller.selectedCategory.value == category;
      return InkWell(
        onTap: () => controller.changeCategory(category),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF7D4A) : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            category,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPostCard(post, int index) {
    final avatarUrl = 'https://i.pravatar.cc/150?img=${(index + 1) % 70}';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    post.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.thumb_up_alt_outlined,
                        color: Colors.orange[300], size: 20),
                    const SizedBox(width: 4),
                    Text('2', style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(width: 16),
                    Icon(Icons.chat_bubble_outline,
                        color: Colors.grey[400], size: 20),
                  ],
                ),
                Icon(Icons.share, color: Colors.grey[400], size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
