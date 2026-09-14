// Opens a Realm file dynamically (no model classes), which upgrades its file format
// to the one of the linked Realm version, then prints the object count of each class.
#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import <Realm/RLMRealmConfiguration_Private.h>
#import <Realm/RLMRealm_Dynamic.h>

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        if (argc != 2) {
            fprintf(stderr, "usage: %s path/to/default.realm\n", argv[0]);
            return 2;
        }
        RLMRealmConfiguration *config = [RLMRealmConfiguration new];
        config.fileURL = [NSURL fileURLWithPath:@(argv[1])];
        config.dynamic = YES;

        NSError *error = nil;
        RLMRealm *realm = [RLMRealm realmWithConfiguration:config error:&error];
        if (!realm) {
            fprintf(stderr, "error: %s\n", error.description.UTF8String);
            return 1;
        }
        printf("schema version: %llu\n", [RLMRealm schemaVersionAtURL:config.fileURL encryptionKey:nil error:nil]);
        for (RLMObjectSchema *objectSchema in realm.schema.objectSchema) {
            printf("%s: %lu\n", objectSchema.className.UTF8String,
                   (unsigned long)[realm allObjects:objectSchema.className].count);
        }
    }
    return 0;
}
