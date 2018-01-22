ifneq (,$(filter $(TARGET_ARCH), arm arm64))

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

# QCameraParameters.h has unused private field.
# QCamera2Hal.cpp, QCamera3HWI.cpp, etc. use GNU old-style field designator extension.
# QCamera3PostProc.cpp has unused label.
# QCamera3HWI.cpp, QCamera3PostProc.cpp etc. have unused variable.
# QCamera3Channel.cpp compares array to null pointer.
# QCamera2Factory.cpp, QCamera3HWI.cpp, etc. have unused parameter.
# QCamera3HWI.cpp has print format error.
LOCAL_CLANG_CFLAGS += \
        -Wno-error=unused-private-field \
        -Wno-error=gnu-designator \
        -Wno-error=unused-label \
        -Wno-error=unused-variable \
        -Wno-error=unused-parameter \
        -Wno-error=tautological-pointer-compare \
        -Wno-error=format

LOCAL_SRC_FILES := \
        util/QCameraCmdThread.cpp \
        util/QCameraQueue.cpp \
        util/QCameraFlash.cpp \
        QCamera2Hal.cpp \
        QCamera2Factory.cpp

#HAL 3.0 source
LOCAL_SRC_FILES += \
        HAL3/QCamera3HWI.cpp \
        HAL3/QCamera3Mem.cpp \
        HAL3/QCamera3Stream.cpp \
        HAL3/QCamera3Channel.cpp \
        HAL3/QCamera3VendorTags.cpp \
        HAL3/QCamera3PostProc.cpp

#HAL 1.0 source
LOCAL_SRC_FILES += \
        HAL/QCamera2HWI.cpp \
        HAL/QCameraMem.cpp \
        HAL/QCameraStateMachine.cpp \
        HAL/QCameraChannel.cpp \
        HAL/QCameraStream.cpp \
        HAL/QCameraPostProc.cpp \
        HAL/QCamera2HWICallbacks.cpp \
        HAL/QCameraParameters.cpp \
        HAL/QCameraThermalAdapter.cpp

LOCAL_CFLAGS := -Wall -Werror
LOCAL_CFLAGS += -DHAS_MULTIMEDIA_HINTS

#HAL 1.0 Flags
LOCAL_CFLAGS += -DDEFAULT_DENOISE_MODE_ON -DHAL3 -DVANILLA_HAL

LOCAL_C_INCLUDES := \
        $(LOCAL_PATH)/stack/common \
        frameworks/native/include/media/hardware \
        frameworks/native/include/media/openmax \
        hardware/qcom/media/msm8974/libstagefrighthw \
        system/media/camera/include \
        $(LOCAL_PATH)/../mm-image-codec/qexif \
        $(LOCAL_PATH)/../mm-image-codec/qomx_core \
        $(LOCAL_PATH)/util \

#HAL 1.0 Include paths
LOCAL_C_INCLUDES += \
        frameworks/native/include/media/hardware \
        device/moto/shamu/camera/QCamera2/HAL

LOCAL_C_INCLUDES += \
        system/libhidl/base/include \
        system/libhidl/transport/token/1.0/utils/include \
        system/core/base/include

# TODO: Is there a cleaner way to add these include directories, without converting the whole thing to .bp?
LOCAL_C_INCLUDES += \
        frameworks/native/libs/nativewindow/include \
        out/soong/.intermediates/hardware/interfaces/graphics/bufferqueue/1.0/android.hardware.graphics.bufferqueue@1.0_genc++_headers/gen \
        out/soong/.intermediates/system/libhidl/transport/base/1.0/android.hidl.base@1.0_genc++_headers/gen \
        out/soong/.intermediates/system/libhidl/transport/manager/1.0/android.hidl.manager@1.0_genc++_headers/gen \
        out/soong/.intermediates/hardware/interfaces/graphics/common/1.0/android.hardware.graphics.common@1.0_genc++_headers/gen \
        out/soong/.intermediates/hardware/interfaces/media/1.0/android.hardware.media@1.0_genc++_headers/gen

LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include

#LOCAL_STATIC_LIBRARIES := libqcamera2_util
LOCAL_C_INCLUDES += \
        hardware/qcom/display/$(TARGET_BOARD_PLATFORM)/libgralloc
LOCAL_C_INCLUDES += \
        hardware/qcom/display/$(TARGET_BOARD_PLATFORM)/libqdutils

LOCAL_SHARED_LIBRARIES := libcamera_client liblog libhardware libutils libcutils libdl libsync
LOCAL_SHARED_LIBRARIES += libmmcamera_interface libmmjpeg_interface libui libcamera_metadata
LOCAL_SHARED_LIBRARIES += libqdMetaData

LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_MODULE := camera.$(TARGET_BOARD_PLATFORM)
LOCAL_MODULE_TAGS := optional

LOCAL_32_BIT_ONLY := true
include $(BUILD_SHARED_LIBRARY)

include $(LOCAL_PATH)/HAL/test/Android.mk

include $(call first-makefiles-under,$(LOCAL_PATH))

endif
