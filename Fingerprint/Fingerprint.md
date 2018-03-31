
# 指纹相关修改
---

## 设置界面指纹修改：


![launcher_welcome_page](http://o8r7cqsy6.bkt.clouddn.com/fingerprint_enroll_animation_1.png)![launcher_welcome_page](http://o8r7cqsy6.bkt.clouddn.com/fingerprint_enroll_animation_2.png)

比如这种调整动画位置很常见

修改点：

	alps/packages/apps/Settings/res/values/dimens.xml

    <!-- Fingerprint -->
    <dimen name="fingerprint_ring_radius">92dip</dimen>
    <dimen name="fingerprint_ring_thickness">4dip</dimen>
    <dimen name="fingerprint_dot_radius">8dp</dimen>
    <dimen name="fingerprint_pulse_radius">50dp</dimen>
    <item name="fingerprint_sensor_location_fraction_x" type="fraction">50%</item>
    +<item name="fingerprint_sensor_location_fraction_y" type="fraction">60%</item>
    <dimen name="fingerprint_find_sensor_graphic_size">190dp</dimen>
    <item name="fingerprint_illustration_aspect_ratio" format="float" type="dimen">2.6</item>
    <dimen name="fingerprint_decor_padding_top">0dp</dimen>
    <dimen name="fingerprint_error_text_appear_distance">16dp</dimen>
    <dimen name="fingerprint_error_text_disappear_distance">-8dp</dimen>
    <dimen name="fingerprint_animation_size">88dp</dimen>
    <dimen name="fingerprint_progress_bar_size">192dp</dimen>
    <dimen name="fingerprint_enrolling_content_margin_top">36dp</dimen>
    <dimen name="fingerprint_in_app_indicator_size">124dp</dimen>
    <dimen name="fingerprint_in_app_indicator_min_size">124dp</dimen>
    <dimen name="fingerprint_in_app_indicator_max_size">264dp</dimen>

    <dimen name="setup_fingerprint_ring_radius">80dip</dimen>
    <dimen name="setup_fingerprint_progress_bar_size">168dp</dimen>

