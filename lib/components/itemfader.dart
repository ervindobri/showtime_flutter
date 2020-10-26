import 'package:flutter/cupertino.dart';

class ItemFader extends StatefulWidget {
  final Widget child;

  const ItemFader({Key key, this.child}) : super(key: key);
  @override
  _ItemFaderState createState() => _ItemFaderState();
}

class _ItemFaderState extends State<ItemFader> with SingleTickerProviderStateMixin{
  int position = 1;
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600)
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut
    );
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, 64 * position * ( 1- _animation.value)),
          child: Opacity(
            opacity: _animation.value,
            child: child,
          ),
        );
      },
    );
  }
  void show(){
    setState(() => position = 1);
    _animationController.forward();
  }
  void hide(){
    setState(() => position = -1);
    _animationController.reverse();
  }
}
