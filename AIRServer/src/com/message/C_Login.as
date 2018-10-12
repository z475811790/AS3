package com.message {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class C_Login extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ACCOUNT:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.message.C_Login.account", "account", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var account:String;

		/**
		 *  @private
		 */
		public static const PASSWORD:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.message.C_Login.password", "password", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var password:String;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.account);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.password);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var account$count:uint = 0;
			var password$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (account$count != 0) {
						throw new flash.errors.IOError('Bad data format: C_Login.account cannot be set twice.');
					}
					++account$count;
					this.account = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (password$count != 0) {
						throw new flash.errors.IOError('Bad data format: C_Login.password cannot be set twice.');
					}
					++password$count;
					this.password = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
