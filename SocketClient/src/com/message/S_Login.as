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
	public dynamic final class S_Login extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ACCOUNT:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.message.S_Login.account", "account", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var account:String;

		/**
		 *  @private
		 */
		public static const ISSUCCESSFUL:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.message.S_Login.isSuccessful", "isSuccessful", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var isSuccessful:Boolean;

		/**
		 *  @private
		 */
		public static const MSG:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.message.S_Login.msg", "msg", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var msg$field:String;

		public function clearMsg():void {
			msg$field = null;
		}

		public function get hasMsg():Boolean {
			return msg$field != null;
		}

		public function set msg(value:String):void {
			msg$field = value;
		}

		public function get msg():String {
			return msg$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.account);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, this.isSuccessful);
			if (hasMsg) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, msg$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var account$count:uint = 0;
			var isSuccessful$count:uint = 0;
			var msg$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (account$count != 0) {
						throw new flash.errors.IOError('Bad data format: S_Login.account cannot be set twice.');
					}
					++account$count;
					this.account = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (isSuccessful$count != 0) {
						throw new flash.errors.IOError('Bad data format: S_Login.isSuccessful cannot be set twice.');
					}
					++isSuccessful$count;
					this.isSuccessful = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 3:
					if (msg$count != 0) {
						throw new flash.errors.IOError('Bad data format: S_Login.msg cannot be set twice.');
					}
					++msg$count;
					this.msg = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
